unit ChatGPT;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Net.HttpClientComponent,
  System.Net.HttpClient, System.Net.URLClient, System.Threading;

type
  TChatGPT = class(TComponent)
  private
    FToken: String;
    FResponse: String;
    FChatModel: String;
    FHttpClient: TNetHTTPClient; // Klient HTTP
    FOnResponse: TProc<string>; // Callback do obsługi odpowiedzi
    function RequestJson(const URL, Token, Question: string): string;
    function ExtractMessage(const JSON: string): string;
  public
    property Token: String read FToken write FToken;
    property Response: String read FResponse;
    property ChatModel: String read FChatModel write FChatModel;
    property OnResponse: TProc<string> read FOnResponse write FOnResponse; // Obsługa odpowiedzi
    procedure SendQuestionAsync(const Question: String);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{ TChatGPT }

constructor TChatGPT.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FChatModel := 'gpt-4'; // Domyślny model
  FHttpClient := TNetHTTPClient.Create(nil); // Tworzenie klienta HTTP
end;

destructor TChatGPT.Destroy;
begin
  FHttpClient.Free; // Zwolnienie klienta HTTP
  inherited;
end;

function TChatGPT.RequestJson(const URL, Token, Question: string): string;
var
  RequestBody: TStringStream;
  Response: IHTTPResponse;
  Params: string;
begin
  Result := '';
  Params := Format(
    '{ "model": "%s", "messages": [ { "role": "user", "content": "%s" } ] }',
    [FChatModel, Question]
  );

  RequestBody := TStringStream.Create(Params, TEncoding.UTF8);
  try
    FHttpClient.ContentType := 'application/json';
    FHttpClient.CustomHeaders['Authorization'] := 'Bearer ' + Token;

    try
      Response := FHttpClient.Post(URL, RequestBody);
      Result := Response.ContentAsString(TEncoding.UTF8);
    except
      on E: ENetHTTPClientException do
        Result := '{"error": "' + E.Message + '"}';
    end;
  finally
    RequestBody.Free;
  end;
end;

function TChatGPT.ExtractMessage(const JSON: string): string;
var
  JSONObj: TJSONObject;
  ChoicesArray: TJSONArray;
  MessageObj: TJSONObject;
begin
  Result := '';
  JSONObj := TJSONObject.ParseJSONValue(JSON) as TJSONObject;
  try
    if Assigned(JSONObj) and JSONObj.TryGetValue<TJSONArray>('choices', ChoicesArray) then
    begin
      if ChoicesArray.Count > 0 then
      begin
        MessageObj := ChoicesArray.Items[0] as TJSONObject;
        if MessageObj.TryGetValue<string>('message.content', Result) then
          Exit;
      end;
    end;
  finally
    JSONObj.Free;
  end;
end;

procedure TChatGPT.SendQuestionAsync(const Question: String);
var
  URL: String;
begin
  URL := 'https://api.openai.com/v1/chat/completions';

  // Uruchomienie wątku asynchronicznego
  TTask.Run(
    procedure
    var
      JsonResponse: string;
      ExtractedMessage: string;
    begin
      try
        JsonResponse := RequestJson(URL, FToken, Question);
        ExtractedMessage := ExtractMessage(JsonResponse);
      except
        on E: Exception do
          ExtractedMessage := '{"error": "' + E.Message + '"}';
      end;

      // Wywołanie zwrotne w głównym wątku
      TThread.Synchronize(nil,
        procedure
        begin
          FResponse := ExtractedMessage;
          if Assigned(FOnResponse) then
            FOnResponse(FResponse);
        end
      );
    end
  );
end;

end.

