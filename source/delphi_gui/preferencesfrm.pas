{
  Copyright 1998-2014 PasDoc developers.

  This file is part of "pasdoc_gui".

  "pasdoc_gui" is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  "pasdoc_gui" is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with "pasdoc_gui"; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

  ----------------------------------------------------------------------------
}

{ This unit implements TPreferences form (run by TPreferences.Execute).

  @author(Michalis Kamburelis)
  @author(Arno Garrels <first name.name@nospamgmx.de>)}

unit PreferencesFrm;

interface

{$R *.dfm}

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TPreferences }

  TPreferences = class(TForm)
    BtnOK: TButton;
    BtnCancel: TButton;
    BtnResetDefaults: TButton;
    EditWWWBrowserCommand: TEdit;
    EditWWWHelpServer: TEdit;
    LabelWWWBrowserCommand: TLabel;
    LabelWWWHelpServer: TLabel;
    cbLoadLastProject: TCheckBox;
    procedure BtnResetDefaultsClick(Sender: TObject);
  private
    { private declarations }
  public
    class procedure Execute;
  end; 

implementation

uses
  WWWBrowserRunnerDM, PasDocGuiSettings;

procedure TPreferences.BtnResetDefaultsClick(Sender: TObject);
begin
  EditWWWBrowserCommand.Text := DefaultWWWBrowserCommand;
  EditWWWHelpServer.Text := DefaultWWWHelpServer;
  cbLoadLastProject.Checked := TRUE;
end;

class procedure TPreferences.Execute;
var
  F: TPreferences;
begin
  F := TPreferences.Create(nil);
  try
    F.EditWWWBrowserCommand.Text := WWWBrowserRunner.BrowserCommand;
    F.EditWWWHelpServer.Text := WWWHelpServer;
    F.cbLoadLastProject.Checked := AutoLoadLastProject;
    if F.ShowModal = mrOK then
    begin
      WWWBrowserRunner.BrowserCommand := F.EditWWWBrowserCommand.Text;
      WWWHelpServer := F.EditWWWHelpServer.Text;
      AutoLoadLastProject := F.cbLoadLastProject.Checked;
    end;
  finally
    F.Free;
  end;
end;

end.

