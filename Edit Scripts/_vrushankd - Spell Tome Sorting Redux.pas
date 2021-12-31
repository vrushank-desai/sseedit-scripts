{
	Changes all spell tome names to be written as "Spell Tome - <School> <Rank> : <Spell Name>" to sort spell tomes in your and vendors inventory.
	Appends '*' to the name if not a vanilla spell.
	Based on https://www.nexusmods.com/skyrimspecialedition/mods/35235

	How to use:
	1) Apply the script on any plugin (it will be applied to all loaded plugins)
	2) If you run it for the first time, enter a name for the new patch
	3) Confirm all the master adding messages
	Repeat every time you add/remove/move mods that add/change spells.
}
unit vrushankd_SpellTomeSortingRedux;

uses 'lilmacelib\framework';
uses 'utilities\utilities';

var
	school_out, level_out, school_in, level_in: array[0..4] of string;

procedure Main;
begin
	//can be edited
	school_out[0] := 'Alteration';
	school_out[1] := 'Conjuration';
	school_out[2] := 'Destruction';
	school_out[3] := 'Illusion';
	school_out[4] := 'Restoration';
	level_out[0] := 'I';
	level_out[1] := 'II';
	level_out[2] := 'III';
	level_out[3] := 'IV';
	level_out[4] := 'V';
	SetFileExclusions('AddItemMenuSE.esp, AddItemMenuLE.esp, AddSpellMenu.esp, "Outfit Switcher.esp"');

	//don't touch these
	school_in[0] := 'Alteration';
	school_in[1] := 'Conjuration';
	school_in[2] := 'Destruction';
	school_in[3] := 'Illusion';
	school_in[4] := 'Restoration';
	level_in[0] := 'Novice';
	level_in[1] := 'Apprentice';
	level_in[2] := 'Adept';
	level_in[3] := 'Expert';
	level_in[4] := 'Master';

 	patch := CreateFileByAuthor('spell tome sorting patcher redux');
 	if not Assigned(patch) then exit;
	EmptyFile(patch);
	SetOverridesToProcess(false, false, true, true);

	ProcessAllFiles('BOOK');

	FinalizePatch(patch);
end;

procedure ProcessRecord(e: IInterface);
var
	spell: IInterface;
	sPerk, school, level, suffix: string;
	i: integer;
begin
	if GetElementEditValues(e, 'DATA\Flags\Teaches Spell') <> '1' then exit;
	
	PrintThisFile();
	
	e := CopyAsOverride(e, patch);

	spell := WinningOverride(LinksTo(ElementByPath(e, 'DATA\Spell')));
	sPerk := GetElementEditValues(spell, 'SPIT\Half-cost Perk');

	// [START] Determine if vanilla or mod-provided spell. Append '*' for latter.
	
	suffix := '*';

	if IsVanillaRecord(spell) then begin
		suffix := '';
	end;

	// [END] Determine if vanilla or mod-provided spell. Append '*' for latter.

	school := school_out[0];
	for i := 0 to 4 do begin
		if pos(school_in[i], sPerk) > 0 then begin
			school := school_out[i];
			break;
		end;
	end;
	level := level_out[0];
	for i := 0 to 4 do begin
		if pos(level_in[i], sPerk) > 0 then begin
			level := level_out[i];
			break;
		end;
	end;

	SetElementEditValues(e, 'FULL', 'Spell Tome - ' + school + ' ' + level + ': ' + GetElementEditValues(spell, 'FULL') + suffix);
end;

end.