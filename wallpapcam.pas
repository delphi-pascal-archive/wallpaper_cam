unit wallpapcam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShlObj, ComObj, XPMan, Buttons, ExtCtrls, jpeg, HTTPGet,
  Registry, ExtDlgs;

type
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    XPManifest1: TXPManifest;
    pap: TImage;
    campap: TImage;
    CB1: TComboBox;
    HTTPG1: THTTPGet;
    Timer1: TTimer;
    od1: TOpenPictureDialog;
    CB2: TComboBox;
    HTTPG2: THTTPGet;
    BitBtn2: TBitBtn;
    Timer2: TTimer;
    procedure OnCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure HTTPGetFileDoneFile(Sender: TObject; FileName: String; FileSize: Integer);
    procedure HTTPG2FileDoneFile(Sender: TObject; FileName: String; FileSize: Integer);
    procedure HTTPGetError(Sender: TObject);
    procedure construction(Sender: TObject);
    procedure constructionm(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject); //Image: TPicture);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

 procedure TForm1.OnCreate(Sender: TObject);
 var  Registre:TRegistry;
 begin
 //Registry := Registre.Create('Control Panel');
 //Registry.WriteString('desktop', 'WallPaper', 'C:\windows\wallpap.bmp' );      //inscription dans le registre
 Registre:= TRegistry.Create;   //du dossier dans lequel se trouve le papier peint

 Registre.RootKey:= HKEY_CURRENT_USER; //
 Registre.OpenKey('Control Panel\Desktop\',True);
 Registre.WriteString('Wallpaper','C:\windows\wallpap.bmp');
 Registre.CloseKey;
 Registre.Free;
 end;
procedure TForm1.Timer1Timer(Sender: TObject);
 begin
 HTTPG1.URL:= CB1.text; //download capture webcam
 HTTPG1.FileName := (ExtractFilePath(Application.ExeName) +'\cam.jpg');  //stockage du fichier téléchargé
 HTTPG1.GetFile;
// ('http://www.salernometeo.it/Webcam/napoli/currentsmall.jpg')lien utilisé en exemple
end;
// fin du téléchargement suite du prog
procedure TForm1.HTTPGetFileDoneFile(Sender: TObject; FileName: String;  FileSize: Integer);
begin
  campap.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'\cam.jpg');
  construction(Self);
end;

procedure TForm1.HTTPGetError(Sender: TObject);
begin
  ShowMessage('Connection interrompue');
end;
procedure TForm1.construction(Sender: TObject);
var
b : TBitmap;
//création canvas
begin
b := TBitmap.Create;
b.PixelFormat := pf24bit;
b.Width := Screen.Width;
b.Height := Screen.Height;
b.Canvas.Brush.color := clBlack;
b.Canvas.FillRect(Rect(0,0,b.Width,b.Height));
b.Canvas.StretchDraw(Rect(0,0,b.Width,b.Height),pap.Picture.Graphic); //dessin du papier peint à la dimension de l'écran

b.Canvas.Draw(0,0, campap.Picture.Graphic);  //ajout de la capture webcam
b.SaveToFile('C:\windows\wallpap.bmp');
SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, nil, SPIF_SENDWININICHANGE); //rafraichissement du bureau
end;
procedure TForm1.BitBtn1Click(Sender: TObject);
begin
if od1.Execute then
Timer1.Enabled := True;
pap.Picture.LoadFromFile(od1.FileName); //choix du fond
Timer1Timer(Self);
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
HTTPG2.URL:= CB2.text; //download capture webcam
 HTTPG2.FileName := (ExtractFilePath(Application.ExeName) +'\camm.jpg');  //stockage du fichier téléchargé
 HTTPG2.GetFile;
end;
procedure TForm1.HTTPG2FileDoneFile(Sender: TObject; FileName: String; FileSize: Integer);
begin
 pap.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'\camm.jpg');
 constructionm(Self);
 end;
procedure TForm1.constructionm(Sender: TObject);
var
b : TBitmap;
//création canvas
begin
b := TBitmap.Create;
b.PixelFormat := pf24bit;
b.Width := Screen.Width;
b.Height := Screen.Height;
b.Canvas.Brush.color := clBlack;
b.Canvas.FillRect(Rect(0,0,b.Width,b.Height));
b.Canvas.StretchDraw(Rect(0,0,b.Width,b.Height),pap.Picture.Graphic); //dessin du papier peint à la dimension de l'écran

b.SaveToFile('C:\windows\wallpap.bmp');
SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, nil, SPIF_SENDWININICHANGE); //rafraichissement du bureau
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
Timer2.Enabled := True;
Timer2Timer(Self);
end;

end.
