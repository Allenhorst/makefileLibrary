import pathlib
import subprocess
import sys
import pprint
import os


RUNNING_DIR = pathlib.Path(os.path.abspath(__file__)).parent

TARGET_DIR = RUNNING_DIR/pathlib.Path("generatedMakefiles")
TARGET_MIGRATION_DIR =  RUNNING_DIR/pathlib.Path("migrations")
ALL_TARGETS = {}



migration_table = {   
	'apply_to_k8s': "DEFINE_apply_to_k8s.mk",
	'get_img_pull_err': "DEFINE_get_img_pull_err.mk",
	'app_name': 'app_name.mk',
	'app_version': 'app_version.mk',
	'build_docker_image': 'build_docker_image.mk',
	'build_docs': 'build_docs_sbt.mk',
	'build_jars': 'build_jars_sbt.mk',
	'deploy': 'deploy_full.mk',
	'deploy_to_k8s': 'deploy_kustomize.mk',
	'env': 'base_envs.mk',
	'help': 'help.mk',
	'image_tag': 'image_tag.mk',
	'increment_major': 'increment_version.mk',
	'increment_patch': 'increment_version.mk',
	'increment_version': 'increment_version_sbt.mk',
	'push_docker_image': 'push_docker_image.mk',
	'push_incremented_version': 'push_incremented_version.mk',
	'push_release_tag': 'push_release_tag.mk',
	'verify': 'verify_python.mk',
	'webhook_image_tag': 'webhook_image_tag.mk'
}


def gen_migration_file(trg_dict):
	content = str()
	return content

for mk in pathlib.Path(TARGET_DIR).iterdir():
	dir_name = str(mk.name)
	full_path = str(TARGET_DIR) + "/" + dir_name + "/Makefile"
	try:
		output = subprocess.check_output("{0} {1} {2} {3}".format("make","-f" , full_path, "list"), shell=True).decode(sys.stdout.encoding)
	except subprocess.CalledProcessError as e: 
		print(e)
		continue
	targets = output.split("\n")
	name = "{0}.migration".format(dir_name)
	filename =  str(pathlib.Path(TARGET_MIGRATION_DIR).joinpath(pathlib.Path(name)))
	os.makedirs(pathlib.Path(TARGET_MIGRATION_DIR) , exist_ok=True)
	targets_dict = dict()
	for target in targets:
		
		if target not in ALL_TARGETS.keys(): 
			ALL_TARGETS[target] = dir_name
		try:
			stepfile = migration_table[target]
		except KeyError:
			stepfile = "no_such_stepfile"
		targets_dict[target] = stepfile
	
	with open(filename, 'w+') as out:
		PP = pprint.PrettyPrinter(indent=4,stream=out)
		PP.pprint(targets_dict)

with open("all_targets.lst", 'w+') as out:
	PP = pprint.PrettyPrinter(indent=4,stream=out)
	PP.pprint(ALL_TARGETS)
