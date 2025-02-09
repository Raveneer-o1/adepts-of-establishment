"""
Unit Data Parser and Validator

This program consolidates all unit parameters from the game files into a single .md file, providing an organized and easy-to-read overview of all unit stats. The .md file serves as a central reference for collaborators, making it convenient to review unit data without diving into the game's deeply nested files. By presenting the parameters in one place, this tool streamlines navigation and ensures clarity, especially since the unit parameters are stored directly within the game files instead of a dedicated data file.

"""

import re
import os
from pathlib import Path

class UnitData:
	def __init__(self, name, level, max_hp, base_damage, armor, attacks, effects = None, faction = "Neutral"):
		"""
		Initialize a UnitData instance.

		Args:
			name (str): The name of the unit.
			level (int): The level of the unit.
			max_hp (int): Maximum HP of the unit.
			base_damage (int): Base damage of the unit.
			armor (int): Armor value of the unit.
			attacks (list[dict]): List of attacks with their properties.
		"""
		self.name = name
		self.level = level
		self.max_hp = max_hp
		self.base_damage = base_damage
		self.armor = armor
		self.attacks = attacks
		self.faction = faction
		self.effects = effects if effects else []

	def __repr__(self):
		return (
			f"name = {self.name}, level = {self.level}\nmax_hp = {self.max_hp}\n"
			f"base_damage = {self.base_damage}\narmor = {self.armor}\n"
			f"attacks:\n{self.attacks}\neffects: {self.effects}"
		)


def generate_md_file(units, output_file):
	"""
	Generate a .md file with the unit data.

	Args:
		units (list[UnitData]): List of UnitData objects.
		output_file (str): Path to the output .md file.
	"""
	with open(output_file, "w", newline='\n') as f:
		f.write("# Units Overview \n\
 \n\
## Unit trees \n\
 \n\
### Empire \n\
 \n\
* [Squire](#squire)  \n\
	* [Knight](#knight) \n\
		* [Knight Master](#knight_master)  \n\
			* [Angel Knight](#angel_knight) \n\
		* [Horseman](#horseman) \n\
			* [Royal Cavalier](#royal_cavalier) \n\
				* [Paladin](#paladin) \n\
	* [Witch hunter](#witch_hunter) \n\
		* [Inquisitor](#inquisitor) \n\
			* [Grand Inquisitor](#grand_inquisitor) \n\
		* [Samurai](#samurai) \n\
			* [Blade Saint](#blade_saint) \n\
 \n\
* [Apprentice](#apprentice) \n\
	* [Elementalist](#elementalist) \n\
		* [Ritualist](#ritualist) \n\
	* [Mage](#mage) \n\
		* [Wizard](#wizard) \n\
			* [White Mage](#white_mage) \n\
				* [Keeper of Knowledge](#keeper_of_knowledge) \n\
				* [Arcanist](#arcanist) \n\
 \n\
* [Archer](#archer) \n\
	* [Marksman](#marksman) \n\
		* [Scout](#scout) \n\
			* [Imperial Ranger](#imperial_ranger) \n\
		* [Assassin](#assassin) \n\
 \n\
* [Acolyte](#acolyte) \n\
	* [Cleric](#cleric) \n\
		* [Matriarch](#matriarch) \n\
			* [Prophetess](#prophetess) \n\
	* [Priest](#priest) \n\
		* [Imperial priest](#imperial_priest) \n\
			* [Hierophant](#hierophant) \n\
 \n\
## Undead \n\
 \n\
* [Death Acolyte](#death_acolyte) \n\
	* [Necromancer](#necromancer) \n\
		* [Vampire](#vampire) \n\
			* [Elder vampire](#elder_vampire) \n\
				* [Vampire Lord](#vampire_lord) \n\
				* [Blood spawn](#blood_spawn) \n\
		* [Lich](#lich) \n\
			* [Archlich](#archlich) \n\
	* [Dark Mage](#dark_mage) \n\
		* [Wraith](#wraith) \n\
			* [Herald of Death](#herald_of_death) \n\
 \n\
* [Ghost](#ghost) \n\
	* [Specter](#specter) \n\
		* [Will-o’-Wisp](#will-o’-wisp) \n\
			* [The eternal](#the_eternal) \n\
		* [Shadow](#shadow) \n\
			* [Vision of Darkness](#vision_of_darkness) \n\
 \n\
* [Wyvern](#wyvern) \n\
	* [Doomdrake](#doomdrake) \n\
		* [Gluttonous Serpent](#gluttonous_serpent) \n\
			* [The Devourer](#the_devourer) \n\
		* [Dreadwyrm](#dreadwyrm) \n\
			* [Undying Nighthunter](#Undying_nighthunter) \n\
				* [Dracolich](#dracolich) \n\
\n\n")
		
		units_by_faction = {}
		for unit in units:
			faction = unit.faction
			print(faction)
			units_by_faction.setdefault(faction, []).append(unit)

		for faction, faction_units in units_by_faction.items():
			f.write(f"### {faction}\n")
			for unit in faction_units:
				f.write(f"#### {unit.name}\n")
				f.write(f"* **Health:** {unit.max_hp}\n")
				f.write(f"* **Attack:** {unit.base_damage}\n")
				f.write(f"* **Defense:** {unit.armor}\n")
				attacks = ", ".join(repr(a) for a in unit.attacks)
				if attacks:
					f.write(f"* **Attacks:** {attacks}\n")
				if unit.effects:
					effects = ", ".join(unit.effects)
					f.write(f"* **Effects:** {effects}\n")
				f.write("\n")


def check_unit_name(units, name):
	for unit in units:
		#print (f"{unit.name} != {name}")
		if unit.name == name:
			return True
	return False

def read_and_compare_md_file(md_file, units):
	"""
	Read a .md file and compare its contents with the list of UnitData objects.

	Args:
		md_file (str): Path to the .md file.
		units (list[UnitData]): List of UnitData objects.

	Returns:
		list[str]: List of discrepancies found, if any.
	"""
	discrepancies = []

	# Read the .md file into a structured format
	with open(md_file, "r", newline='\n') as f:
		lines = f.readlines()

	current_unit = None
	unit_data = {}
	for line in lines:
		line = line.strip()
		if line.startswith("#### "):
			unit_name = line[5:]
			current_unit = unit_name
			unit_data[unit_name] = {"Health": None, "Attack": None, "Defense": None, "Attacks": []}
		elif current_unit:
			if line.startswith("* **Health:**"):
				unit_data[current_unit]["Health"] = int(line.split(":**")[1].strip())
			elif line.startswith("* **Attack:**"):
				unit_data[current_unit]["Attack"] = int(line.split(":**")[1].strip())
			elif line.startswith("* **Defense:**"):
				unit_data[current_unit]["Defense"] = int(line.split(":**")[1].strip())
			elif line.startswith("* **Attacks:**"):
				attacks = [ln.strip().strip("'") for ln in line.split(":**")[1].split("',")]
				unit_data[current_unit]["Attacks"] = attacks
			elif line.startswith("* **Effects:**"):
				effects = [ln.strip().strip("'") for ln in line.split(":**")[1].split("',")]
				unit_data[current_unit]["Effects"] = effects

	# Validate unit names and stats
	for data in unit_data:
		if not check_unit_name(units, data):
			discrepancies.append(f"Unit {data} is in .md file but no such unit found!")


	# Compare the data from the .md file with the UnitData list
	for unit in units:
		if unit.name not in unit_data:
			discrepancies.append(f"Unit {unit.name} missing in .md file.")
			continue

		md_unit = unit_data[unit.name]
		if md_unit["Health"] != unit.max_hp:
			discrepancies.append(f"{unit.name}: Health mismatch MD: {md_unit['Health']}, Data: {unit.max_hp}\n")
		if md_unit["Attack"] != unit.base_damage:
			discrepancies.append(f"{unit.name}: Attack mismatch MD: {md_unit['Attack']}, Data: {unit.base_damage}\n")
		if md_unit["Defense"] != unit.armor:
			discrepancies.append(f"{unit.name}: Defense mismatch MD: {md_unit['Defense']}, Data: {unit.armor}\n")
		if (md_unit["Attacks"]) != unit.attacks:
			discrepancies.append(f"{unit.name}: Attacks mismatch \nMD({len(md_unit["Attacks"])}): {md_unit['Attacks']}, \nData({len(unit.attacks)}): {unit.attacks}\n")

	return discrepancies




class UnitParser:
	def __init__(self, file_patterns_path):
		self.file_patterns_path = Path(file_patterns_path)
		self.file_patterns = []
		self.units_data = {}

	def load_file_patterns(self):
		"""Load regex patterns from the patterns file."""
		with self.file_patterns_path.open("r") as file:
			self.file_patterns = [line.strip() for line in file if line.strip() and not line.startswith("#")]

	def parse_unit_file(self, file_path):
		"""Parse a unit file to extract relevant parameters."""
		with open(file_path, "r") as file:
			content = file.read()

		unit_data = {}


		# Extract the [node name="UnitParameters"] section
		unit_parameters = re.search(r'\[node name="UnitParameters".*?\](.*?)\n\[', content, re.S)
		if not unit_parameters:
			unit_parameters = re.search(r'\[node name="UnitParameters".*?\](.*?)\Z', content, re.S)
		if unit_parameters:
			params_section = unit_parameters.group(1)
			unit_data['level'] = self._extract_value(params_section, r'level = (\d+)')
			base_parameters_id = self._extract_value(params_section, r'base_paramaters = SubResource\("(.*?)"\)')
			unit_data['base_parameters_id'] = base_parameters_id
		else:
			print (f"In the file {file_path} unit is not found!")
			return None


		# Extract unit name
		unit_name = re.search(r'unit_name = \"(.*?)\"', content, re.S)
		if not unit_name:
			print (f"In the file {file_path} 'unit_name' is not found!")
			return None
		unit_data['unit_name'] = unit_name.group(1)


		# Extract [id="<ID>"] section using the ID from UnitParameters
		if 'base_parameters_id' in unit_data:
			id_section = re.search(rf'\[sub_resource type="Resource" id="{unit_data["base_parameters_id"]}"\](.*?)\n\[', content, re.S)
			if id_section:
				id_params = id_section.group(1)
				unit_data['max_HP'] = self._extract_value(id_params, r'max_HP = (\d+)')
				unit_data['base_damage'] = self._extract_value(id_params, r'base_damage = (\d+)')
				unit_data['armor'] = self._extract_value(id_params, r'armor = (\d+)')
			else:
				# if no overwritten parameters found, use defauld values
				print(f"For unit '{unit_name.group(1)}' no parameters were found, using standart values!")
				unit_data['max_HP'] = "100"
				unit_data['base_damage'] = "30"
				unit_data['armor'] = "0"

		# Extract all [node name="UnitAttack"] sections
		unit_attacks = re.findall(r'\[node name="UnitAttack".*?\](.*?)\n\[', content, re.S) + \
				re.findall(r'\[node name="UnitAttack".*?\](.*?)\n\Z', content, re.S)
		
		# Find all effects in the file
		effects = re.findall(
			r'AppliedEffects/Scenes/(\w+)\.tscn',
			content
		)

		attacks = []
		for attack in unit_attacks:
			attack_data = \
				'accuracy: ' + self._extract_value(attack, r'accuracy = ([0-9.]+)') + \
				', damage_multiplier: ' + self._extract_value(attack, r'damage_multiplier = ([0-9.]+)') + \
				', initiative: ' + self._extract_value(attack, r'initiative = (\d+)') + \
				', targets_needed: ' + self._extract_value(attack, r'targets_needed = (\d+)')
			attacks.append(attack_data)
		unit_data['attacks'] = attacks

		unit = UnitData( \
			unit_data['unit_name'], \
			int(unit_data['level']), \
			int(unit_data['max_HP']), \
			int(unit_data['base_damage']), \
			int(unit_data['armor']), \
			unit_data['attacks'], \
			effects
			)

		return unit

	def _extract_value(self, text, pattern):
		"""Extract a value using a regex pattern."""
		match = re.search(pattern, text)
		return match.group(1) if match else "0"

	def find_unit_files(self):
		"""Find all unit files matching the regex patterns."""
		unit_files = []
		for pattern in self.file_patterns:
			unit_files.extend((Path() / ".." / "Combat" / "Units" / "Derived units").rglob(pattern))
		return unit_files




	def consolidate_units(self):
		"""Consolidate unit data from all matching files."""
		self.load_file_patterns()
		unit_files = self.find_unit_files()

		for unit_file in unit_files:
			unit_data = self.parse_unit_file(unit_file)
			#print (f"INSIDE: {repr(unit_data)}")
			#if unit_data.name == 'unit_name':
			if unit_data:
				self.units_data[unit_data.name] = unit_data
		return self.units_data


def initialize_parser():
	print ("Initializing parser...")
	parser = UnitParser("unit_file_patterns.txt")
	unit_list = parser.consolidate_units()
	units = unit_list.values()	
	print ("Files parsed successfully.\n")


	print("Reading .md file...")
	discrepancies = read_and_compare_md_file("Units.md", units)
	if discrepancies:
		print("\nDiscrepancies found:")
		for d in discrepancies:
			print(d)
	else:
		print("No discrepancies found.")

	return (unit_list, units)

def print_units(units):
	print(f"\n{len(units)} units stored:")
	print("==============")
	for unit in units:
		print(repr(unit))
		print("==============")

if __name__ == "__main__":
	os.system('cls')

	(unit_list, units) = initialize_parser()

	while True:
		user_input = input("\n(0 - exit \
			\n1 - rewrite .md file with parsed data\
			\n2 - read unit files (update data)\
			\n3 - print unit data)\
			\nWaiting for input...\n")
		#print(f"Recognized {user_input}")

		match user_input:
			case "0":
				break
			case "1":
				print ("Generating .md file...")
				generate_md_file(units, "Units.md")
			case "2":
				(unit_list, units) = initialize_parser()
			case "3":
				print_units(units)