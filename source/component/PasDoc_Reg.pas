{
  Copyright 1998-2014 PasDoc developers.

  This file is part of "PasDoc".

  "PasDoc" is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  "PasDoc" is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with "PasDoc"; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

  ----------------------------------------------------------------------------
}

{ @abstract(Registers the PasDoc components into the IDE. )
  @author(Ralf Junker (delphi@zeitungsjunge.de))
  @author(Johannes Berg <johannes@sipsolutions.de>) 
  @author(Michalis Kamburelis)
  @cvs($Date: 2014-05-21 19:57:07 +0000 (Wed, 21 May 2014) $)  
  
  TODO: We have some properties in TPasDoc and generators components that
  should be registered with filename editors.
}

unit PasDoc_Reg;

{$I pasdoc_defines.inc}

interface

{ Registers the PasDoc components into the IDE. }
procedure Register;

implementation

uses
  Classes,
  PasDoc_Base,
  PasDoc_GenHtml,
  PasDoc_GenLatex,
  PasDoc_GenHtmlHelp;

procedure Register;
begin
  RegisterComponents('PasDoc', [TPasDoc, THTMLDocGenerator, TTexDocGenerator,
    THTMLHelpDocGenerator]);
end;

end.
