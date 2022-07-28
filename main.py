from pprint import pprint
from jinja2 import Environment, FileSystemLoader
import pathlib
import argparse
import logging
import sys
import os
###

STEPS_DIR = pathlib.Path("generalStepsLibrary")
CUSTOM_STEPS_DIR = pathlib.Path("customStepsLibrary")
###TEMPLATES_DIR = pathlib.Path("makefiles")

###

logging.basicConfig(format = u'[%(asctime)s] %(filename)s[LINE:%(lineno)d]# %(levelname)-8s %(message)s', level = logging.DEBUG)
logging.getLogger('main').setLevel(logging.WARNING)

####

class NoTemplateException(Exception):
	pass

def write_makefile(pr_name: str, output: str, output_dir: pathlib.Path):
	RUNNING_DIR = pathlib.Path(os.path.abspath(__file__)).parent
	full_file_name = f"Makefile"
	prj_path = pathlib.Path(str(pr_name))
	print(f"Writing generated makefile to {RUNNING_DIR/output_dir/prj_path}")
	os.makedirs(RUNNING_DIR/output_dir/pathlib.Path(str(pr_name)), exist_ok=True)
	with open(RUNNING_DIR/output_dir/pathlib.Path(str(pr_name))/pathlib.Path(full_file_name), "w+") as f:
		try:
			f.write(output)
		except Exception as e: 
			logging.error(f"Failed to write proccessed template with name {full_file_name}. Error was {e}")

def read_tmpl(tmpl_path: pathlib.Path):
	print(f"Folder to search templates is : {tmpl_path}")
	if tmpl_path.exists() and tmpl_path.is_dir():
		file_loader = FileSystemLoader(str(tmpl_path))
		env = Environment(loader=file_loader)

		template = env.get_template('Makefile.j2')
		return template
	else:
		
		raise NoTemplateException


def parse_steps(steps_dir: pathlib.Path):
	filelst = {}
	ruleslist = {}
	if steps_dir.exists() and steps_dir.is_dir():
		for file in pathlib.Path(steps_dir).iterdir(): 
			filelst[str(file.name).split(".mk")[0]] = file

		for file in filelst.keys():
			with open(filelst[file], "r") as f:
				content = f.read()
			ruleslist[file] = content.strip()

	return ruleslist


def build(pr_name: str, base_Dir: str, out_dir: pathlib.Path):
	RUNNING_DIR = pathlib.Path(os.path.abspath(__file__)).parent
	try:
		templ = read_tmpl(pathlib.Path(base_Dir)/pathlib.Path(pr_name))
	except NoTemplateException:
		logging.error(f"Failed to read template in given folder {pathlib.Path(base_Dir)/pathlib.Path(pr_name)}, please check given path")
		sys.exit(1)
	general_rules = parse_steps(RUNNING_DIR/STEPS_DIR)
	custom_rules = parse_steps(RUNNING_DIR/CUSTOM_STEPS_DIR)
	# merge dicts with steps
	rules = {**general_rules, **custom_rules}
	output = templ.render(ruleslist=rules)
	print(output)
	write_makefile(pr_name, output, out_dir)


def generate_all(base_Dir: str, out_dir: pathlib.Path):
	print(f"Input folder for templates : {base_Dir}, output folder: {out_dir}")
	RUNNING_DIR = pathlib.Path(os.path.abspath(__file__)).parent
	rules = parse_steps(RUNNING_DIR/STEPS_DIR)

	md_dirs = [f for f in pathlib.Path(base_Dir).iterdir() if f.is_dir()]
	for mk in md_dirs:
		try:
			full_path = pathlib.Path(mk)
			print(f"path to makefile is {full_path}")
			templ = read_tmpl(full_path)
		except NoTemplateException:
			logging.error(f"Failed to read template in given folder {mk}, please check given path")
			continue
		output = templ.render(ruleslist=rules)
		print(f"Going to write makefile for {mk.name} to folder {out_dir} ")
		write_makefile(str(mk.name), output, out_dir)


if __name__ == "__main__" :
	parser = argparse.ArgumentParser(description='Makefile builder')
	parser.add_argument(
		'action',
		type=str,
		default="build",
		help='choose action, currently only build or generate are supported'
	)

	parser.add_argument(
		'project',
		type=str,
		default="",
		help='choose project name for build step, generate ignores this parameter'
	)

	parser.add_argument(
		'--indir',
		type=str,
		default="",
		help='Name of folder with makefiles templates',
		required=False
	)
	parser.add_argument(
		'--outdir',
		type=str,
		default="",
		help='Name of folder for generated makefiles',
		required=False
	)

	input_args = parser.parse_args()
	##pprint(input_args)
	GENERATED_MK_DIR = pathlib.Path(input_args.outdir) if pathlib.Path(input_args.outdir) else pathlib.Path("generatedMakefiles")
	TEMPLATES_DIR = pathlib.Path(input_args.indir) if pathlib.Path(input_args.indir) else pathlib.Path("makefiles")
	RUNNING_DIR = pathlib.Path(os.path.abspath(__file__)).parent

	## debug logging
	print (f"GENERATED_MK_DIR is {GENERATED_MK_DIR}\n")
	print (f"TEMPLATES_DIR is {TEMPLATES_DIR}\n")
	print (f"RUNNING_DIR is {RUNNING_DIR}\n")
	##	
	if input_args.action == "build" and input_args.project :
		build(input_args.project, RUNNING_DIR/TEMPLATES_DIR, GENERATED_MK_DIR)
	elif input_args.action == "generate" :
		generate_all(RUNNING_DIR/TEMPLATES_DIR, RUNNING_DIR/GENERATED_MK_DIR)
	else:
		logging.warning("Operation not supported, use <python3 main.py --help> for usage information")
