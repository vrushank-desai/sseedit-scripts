unit vrushankd_HideModMapMarkers;

uses 'lilmacelib\framework';
uses 'utilities\utilities';

var
	i, j: integer;
	patch, worldspace: IInterface;
	visibleFlagExists: boolean;

procedure Main;
begin
 	patch := CreateFileByAuthor('hide mod map markers patcher');
 	if not Assigned(patch) then exit;
	EmptyFile(patch);
	SetOverridesToProcess(false, false, true, true);

	ProcessSelectedFiles('WRLD\REFR');

	FinalizePatch(patch);
end;

procedure ProcessRecord(ref: IInterface);
begin

	if (GetElementNativeValues(ref, 'NAME') <> $00000010) then exit;

	visibleFlagExists := ElementExists(ref, 'Map Marker\FNAM\Visible');
	if not visibleFlagExists then exit;

	worldspace := GetParentWorldSpaceForCellReference(ref);

	if not Assigned(worldspace) or not IsVanillaRecord(worldspace) then exit;

	PrintThisFile();
	ref := CopyAsOverride(ref, patch);

	if visibleFlagExists then begin
		Remove(ElementByPath(ref, 'Map Marker\FNAM\Visible'));
	end;
	
	if ElementExists(ref, 'Map Marker\FNAM\Can Travel To') then begin
		Remove(ElementByPath(ref, 'Map Marker\FNAM\Can Travel To'));
	end;
end;

end.