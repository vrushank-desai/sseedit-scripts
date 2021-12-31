unit utilities_utility;

const
	VanillaMasters = 'Skyrim.esm, Update.esm, Dawnguard.esm, HearthFires.esm, Dragonborn.esm,';

{
  IsVanillaRecord:
  Returns true if input record (master or overridden) is from one of the vanilla masters.
}
function IsVanillaRecord(r: IInterface): boolean;
var
	record_filename: string;
	record_file: IwbFile;
begin
	if not Assigned(r) then begin
		Result := false;
	end else begin
		record_file := GetFile(MasterOrSelf(r));
		record_filename := GetFileName(record_file);

		Result := Pos(record_filename, VanillaMasters) > 0
	end;
end;

{
  FileByName:
  Gets a file from a filename.
  
  Example usage:
  f := FileByName('Skyrim.esm');
}
function FileByName(s: string): IInterface;
var
  i: integer;
begin
	Result := nil;
	for i := 0 to FileCount - 1 do begin
		if GetFileName(FileByIndex(i)) = s then begin
			Result := FileByIndex(i);
			break;
		end;
	end;
end;

{
  GetParentWorldSpaceForCellReference:
  Returns the parent worldspace (WRLD) record for the input cell reference. If the reference is not a cell reference, returns nil.
}
function GetParentWorldSpaceForCellReference(ref: IInterface): IInterface;
var
  cell, worldspace: IInterface;
begin
	if (Signature(ref) <> 'REFR') then begin
		Result := nil;
	end;
	
	cell := WinningOverride(LinksTo(ElementByIndex(ref, 0)));
	worldspace := LinksTo(ElementByIndex(cell, 0));
	
	if Assigned(worldspace) then begin
		worldspace := WinningOverride(worldspace);
	end;
	
	Result := worldspace;
end;

end.