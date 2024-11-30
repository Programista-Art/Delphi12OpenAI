unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,ChatGPT;

type
  TForm1 = class(TForm)
    MemoAsk: TMemo;
    MemoAnswer: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    EditApiKey: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    //Asynchroniczne generowanie
    procedure AskChatGpt;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  FChatgpt : TCHATGPT;
  ChooseModelGPT: String;
  KeyChatGPT: string;
  ModelIndex: Integer;

implementation

{$R *.dfm}

procedure TForm1.AskChatGpt;
var
  ChatGPT: TChatGPT;
begin
ChatGPT := TChatGPT.Create(Self);
  try
    ChatGPT.Token := EditApiKey.Text; //Api Key ChatGPT
    ChatGPT.ChatModel := 'chatgpt-4o-latest'; // model GPT
    ChatGPT.OnResponse :=
      procedure(Response: string)
      begin
        MemoAnswer.Lines.Text := Response; // Viewing responses in Memo
      end;

    ChatGPT.SendQuestionAsync(MemoAsk.Text); //You promt
  except
    on E: Exception do
      ShowMessage('An error occurred: ' + E.Message);
  end;
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  AskChatGpt;
end;


end.
