object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Demo - library ChatGPT in Delphi 12 by Programista Art'
  ClientHeight = 417
  ClientWidth = 614
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  Position = poMainFormCenter
  TextHeight = 15
  object MemoAsk: TMemo
    Left = 0
    Top = 328
    Width = 614
    Height = 89
    Align = alBottom
    TabOrder = 0
    ExplicitLeft = -8
    ExplicitTop = 383
    ExplicitWidth = 566
  end
  object MemoAnswer: TMemo
    Left = 0
    Top = 0
    Width = 614
    Height = 304
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    ExplicitWidth = 566
    ExplicitHeight = 328
  end
  object Panel1: TPanel
    Left = 0
    Top = 304
    Width = 614
    Height = 24
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 328
    ExplicitWidth = 566
    object Button1: TButton
      Left = 538
      Top = 1
      Width = 75
      Height = 22
      Align = alRight
      Caption = 'ASK'
      TabOrder = 0
      OnClick = Button1Click
      ExplicitLeft = 496
      ExplicitTop = -4
    end
    object EditApiKey: TEdit
      Left = 1
      Top = 1
      Width = 537
      Height = 22
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 1
      TextHint = 'Your API Key ChatGPT'
      ExplicitWidth = 464
    end
  end
end
