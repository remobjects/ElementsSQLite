namespace RemObjects.Elements.RTL.SQLite;
{
  On .NET this requires sqlite3.dll from the sqlite website
  On OSX/iOS this uses the system sqlite
  On Android it uses the standard Android sqlite support
  On Java it uses JDBC and requires https://bitbucket.org/xerial/sqlite-jdbc/ to be installed.
}
interface

{$IFDEF PUREJAVA}
uses
  java.sql;
{$ELSEIF COCOA}
uses
  libsqlite3, Foundation;
{$ENDIF}

type
  SQLiteConnection = public class//{$IFDEF ECHOES}(IDisposable){$ENDIF}
  private
    {$IFDEF ECHOES or COCOA}
    fHandle: IntPtr;
    fInTrans: Boolean;
    method Prepare(aSQL: String; aArgs: array of Object): Int64;
    {$ENDIF}
    method get_InTransaction: Boolean;
  protected
  public
    constructor(aFilename: String; aReadOnly: Boolean := false; aCreateIfNeeded: Boolean := false);

    property InTransaction: Boolean read get_InTransaction;
    method BegInTransaction;
    method Commit;
    method Rollback;

    // insert and return the last insert id
    method ExecuteInsert(aSQL: String; params aArgValues: array of Object): Int64;
    // execute and return the number of affected rows
    method Execute(aSQL: String; params aArgValues: array of Object): Int64;
    // select
    method ExecuteQuery(aSQL: String; params aArgValues: array of Object): SQLiteQueryResult;
    method Close;//{$IFDEF ECHOES}implements IDisposable.Dispose;{$ENDIF}
    {$IFDEF COCOA}finalizer;{$ENDIF}
  end;

  SQLiteQueryResult = public {$IFDEF JAVA}interface{$ELSE}class{$ENDIF}
  //{$IFDEF PUREJAVA}mapped to ResultSet{$ENDIF}
  //{$IFDEF ANDROID}mapped to android.database.Cursor{$ENDIF}{$IFDEF ECHOES}(IDisposable){$ENDIF}
  private
    {$IFDEF ECHOES or COCOA}
    fDB: IntPtr;
    fRes: IntPtr;
    {$IFDEF ECHOES}
    fNames: System.Collections.Generic.Dictionary<String, Integer>;
    {$ELSE}
    fNames: NSMutableDictionary;
    {$ENDIF}
    {$ENDIF}
    method get_IsNull(aIndex: Integer): Boolean;
    method get_ColumnCount: Integer;
    method get_ColumnName(aIndex: Integer): String;
    method get_ColumnIndex(aName: String): Integer;
  public
    {$IFDEF ECHOES or COCOA}
    constructor(aDB, aRes: Int64);
    {$ENDIF}
    property ColumnCount: Integer read get_ColumnCount;
    property ColumnName[aIndex: Integer]: String read get_ColumnName;
    property ColumnIndex[aName: String]: Integer read get_ColumnIndex;
    // starts before the first record:
    method Next: Boolean;

    property IsNull[aIndex: Integer]: Boolean read get_IsNull;
    method GetInt32(aIndex: Integer): nullable Integer;
    method GetInt64(aIndex: Integer): nullable Int64;
    method GetDouble(aIndex: Integer): nullable Double;
    method GetBytes(aIndex: Integer): array of {$IFDEF JAVA}SByte{$ELSE}Byte{$ENDIF};
    method GetString(aIndex: Integer): String;

    method GetInt32(aName: String): nullable Integer;
    method GetInt64(aName: String): nullable Int64;
    method GetDouble(aName: String): nullable Double;
    method GetBytes(aName: String): array of {$IFDEF JAVA}SByte{$ELSE}Byte{$ENDIF};
    method GetString(aName: String): String;

    method Close;//{$IFDEF ECHOES}implements IDisposable.Dispose;{$ENDIF}
    {$IFDEF COCOA}finalizer;{$ENDIF}
  end;
  //{$IFDEF ANDROID}
  //SQLiteHelpers = public static class
  //public
    //class method ArgsToString(arr: array of Object): array of String;
    //class method BindArgs(st: android.database.sqlite.SQLiteStatement; aArgs: array of Object);
  //end;
  //{$ENDIF}
  //{$IFDEF PUREJAVA}
  //SQLiteHelpers = public class
  //public
    //class method SetParameters(st: PreparedStatement; aValues: array of Object);
    //class method ExecuteAndGetLastInsertId(st: PreparedStatement): Int64;
  //end;
  //{$ENDIF}

  {$IF ECHOES OR COCOA}
  SQLiteException = public class(Exception)
  public
    constructor(s: String);
  end;
  {$ENDIF}
  {$IFDEF ANDROID}
  SQLiteException = public android.database.sqlite.SQLiteException;
  {$ENDIF}
  {$IFDEF PUREJAVA}
  SQLiteException = public java.sql.SQLException;
  {$ENDIF}

implementation

constructor SQLiteConnection(aFilename: String; aReadOnly: Boolean := false; aCreateIfNeeded: Boolean := false);
begin
  {$IFDEF PUREJAVA}
  &Class.forName('org.sqlite.JDBC');
  var config := new java.util.Properties;
  if aReadonly then
    config.setProperty('open_mode', '1');
  exit DriverManager.getConnection('jdbc:sqlite:' + aFilename, config);
  {$ELSEIF ANDROID}
  exit android.database.sqlite.SQLiteDatabase.openDatabase(aFilename, nil,
    ((if aReadOnly then android.database.sqlite.SQLiteDatabase.OPEN_READONLY else android.database.sqlite.SQLiteDatabase.OPEN_READWRITE) or
    (if aCreateIfNeeded then android.database.sqlite.SQLiteDatabase.CREATE_IF_NECESSARY else 0)));
  {$ELSEIF ECHOES}
  var lRes:= sqlite3_open_v2(aFilename, var fHandle,
    (if aReadOnly then SQLITE_OPEN_READONLY else SQLITE_OPEN_READWRITE) or
    (if aCreateIfNeeded then SQLITE_OPEN_CREATE else 0), nil);
  CheckSQLiteResultAndRaiseException(fHandle, lRes);
  {$ELSEIF COCOA}
  var lRes:= sqlite3_open_v2(NSString(aFilename).UTF8String, ^^sqlite3(@fHandle),
    (if aReadOnly then SQLITE_OPEN_READONLY else SQLITE_OPEN_READWRITE) or
    (if aCreateIfNeeded then SQLITE_OPEN_CREATE else 0), nil);
  CheckSQLiteResultAndRaiseException(fHandle, lRes);
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteConnection.BegInTransaction;
begin
  {$IFDEF PUREJAVA}
  mapped.setAutoCommit(false);
  {$ELSEIF ECHOES or COCOA}
  if fInTrans then raise new SQLiteException('Already in transaction');
  fInTrans := true;
  Execute('begin transaction');
  {$ELSEIF ANDROID}
  mapped.begInTransaction;
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteConnection.Commit;
begin
  {$IFDEF PUREJAVA}
  mapped.commit;
  {$ELSEIF ECHOES or COCOA}
  if fInTrans then raise new SQLiteException('Not in an transaction');
  Execute('commit');
  fInTrans := false;
  {$ELSEIF ANDROID}
  mapped.setTransactionSuccessful;
  mapped.endTransaction;
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteConnection.Rollback;
begin
  {$IFDEF PUREJAVA}
  mapped.rollback;
  {$ELSEIF ECHOES or COCOA}
  if fInTrans then raise new SQLiteException('Not in an transaction');
  Execute('rollback');
  fInTrans := false;
  {$ELSEIF ANDROID}
  mapped.endTransaction;
    {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}

end;

{$IFDEF ECHOES or COCOA}
method SQLiteConnection.Prepare(aSQL: String; aArgs: array of Object): Int64;
begin
  {$IFDEF COCOA}
  var res: IntPtr := nil;
  var data := NSString(aSQL).UTF8String;
  CheckSQLiteResultAndRaiseException(fHandle, sqlite3_prepare_v2(^sqlite3(fHandle), data, strlen(data), ^^sqlite3_stmt(@res), nil));
  for i: Integer := 0 to length(aArgs) -1 do begin
    var o := aArgs[i];
    if o = nil then
      sqlite3_bind_null(^sqlite3_stmt(res), i + 1)
    else if o is NSNumber then begin
      var r := NSNumber(o);
      case r.objCType of
        'f': sqlite3_bind_double(^sqlite3_stmt(res), i + 1, r.floatValue);
        'd': sqlite3_bind_double(^sqlite3_stmt(res), i + 1, r.doubleValue);
      else
        sqlite3_bind_int64(^sqlite3_stmt(res), i + 1, r.longLongValue);
      end;
    end else begin
      var s := coalesce(NSString(o), o.description);
      sqlite3_bind_text16(^sqlite3_stmt(res), i + 1, s.cStringUsingEncoding(NSStringEncoding.NSUnicodeStringEncoding), -1, nil);
    end;
  end;
  result := res;
  {$ELSE}
  var res := IntPtr.Zero;
  var data := System.Text.Encoding.UTF8.GetBytes(aSQL);
  CheckSQLiteResultAndRaiseException(fHandle, sqlite3_prepare_v2(fHandle, data, data.Length, var res, IntPtr.Zero));
  for i: Integer := 0 to length(aArgs) -1 do begin
    var o := aArgs[i];
    if o = nil then
      sqlite3_bind_null(res, i + 1)
    else if o is array of Byte then
      sqlite3_bind_blob(res, i + 1, array of Byte(o), length(array of Byte(o)), IntPtr.Zero)
    else if o is Double then
      sqlite3_bind_double(res, i + 1, Double(o))
    else if o is Int64 then
      sqlite3_bind_int64(res, i + 1, Int64(o))
    else if o is Integer then
      sqlite3_bind_int(res, i + 1, Integer(o))
    else
      sqlite3_bind_text16(res, i + 1, String(o), -1, IntPtr.Zero);
  end;
  result := res;
  {$ENDIF}
end;
{$ENDIF}

method SQLiteConnection.ExecuteQuery(aSQL: String; params aArgValues: array of Object): SQLiteQueryResult;
begin
  {$IFDEF PUREJAVA}
  var st := mapped.prepareStatement(aSQL);
  SetParameters(st, aArgValues);
  exit st.executeQuery();
  {$ELSEIF ECHOES or COCOA}
  exit new SQLiteQueryResult(fHandle, Prepare(aSQL, aArgValues));
  {$ELSEIF ANDROID}
  exit mapped.rawQuery(aSQL, ArgsToString(aArgValues));
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteConnection.ExecuteInsert(aSQL: String; params aArgValues: array of Object): Int64;
begin
  {$IFDEF PUREJAVA}
  var st := mapped.prepareStatement(aSQL);
  SetParameters(st, aArgValues);
  exit  ExecuteAndGetLastInsertID(st);
  {$ELSEIF ECHOES or COCOA}
  var res: IntPtr := Prepare(aSQL, aArgValues);
  var &step := {$IFDEF ECHOES}sqlite3_step(res){$ELSE}sqlite3_step(^sqlite3_stmt(res)){$ENDIF};
  if &step <> {{$IFDEF ECHOES}{{$ENDIF}SQLITE_DONE then begin
    {$IFDEF ECHOES}sqlite3_finalize(res){$ELSE} sqlite3_finalize(^sqlite3_stmt(res)){$ENDIF};
    CheckSQLiteResultAndRaiseException(fHandle, &step);
    exit 0;
  end;
  var revs := {$IFDEF ECHOES}sqlite3_last_insert_rowid(fHandle){$ELSE}sqlite3_last_insert_rowid(^sqlite3(fHandle)){$ENDIF};
  {$IFDEF ECHOES}sqlite3_finalize(res){$ELSE} sqlite3_finalize(^sqlite3_stmt(res)){$ENDIF};
  exit revs;
  {$ELSEIF ANDROID}
  using st := mapped.compileStatement(aSQL) do begin
   BindArgs(st, aArgValues);
    exit st.executeInsert();
  end;
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteConnection.Execute(aSQL: String; params aArgValues: array of Object): Int64;
begin
  {$IFDEF PUREJAVA}
  var st := mapped.prepareStatement(aSQL);
  SetParameters(st, aArgValues);
  exit st.executeUpdate;
  {$ELSEIF ECHOES or COCOA}
  var res: IntPtr := Prepare(aSQL, aArgValues);
  var &step := {$IFDEF ECHOES}sqlite3_step(res){$ELSE}sqlite3_step(^sqlite3_stmt(res)){$ENDIF};
  if &step <> SQLITE_DONE then begin
    {$IFDEF ECHOES}sqlite3_finalize(res){$ELSE} sqlite3_finalize(^sqlite3_stmt(res)){$ENDIF};
    CheckSQLiteResultAndRaiseException(fHandle, &step);
    exit 0;
  end;
  var revs := {$IFDEF ECHOES}sqlite3_changes(fHandle){$ELSE}sqlite3_changes(^sqlite3(fHandle)){$ENDIF};
  {$IFDEF ECHOES}sqlite3_finalize(res){$ELSE} sqlite3_finalize(^sqlite3_stmt(res)){$ENDIF};
  exit revs;

  {$ELSEIF ANDROID}
  using st := mapped.compileStatement(aSQL) do begin
   BindArgs(st, aArgValues);
    exit st.executeUpdateDelete();
  end;
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteConnection.get_InTransaction: Boolean;
begin
  {$IFDEF PUREJAVA}
  exit not mapped.AutoCommit;
  {$ELSEIF ECHOES or COCOA}
  exit fInTrans;
  {$ELSEIF ANDROID}
  exit mapped.InTransaction;
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteConnection.Close;
begin
  {$IFDEF COOPER}
  mapped.Close();
  {$ELSEIF ECHOES}
  if fHandle <> nil then
    sqlite3_close_v2(fHandle);
  fHandle := nil;
  {$ELSEIF NOUGAT}
  if fHandle <> IntPtr(0) then
    sqlite3_close_v2(^sqlite3(fHandle));
  fHandle := IntPtr(0);
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

{$IFDEF COCOA}finalizer SQLiteConnection;
begin
  Close;
end;
{$ENDIF}


{$IFDEF ANDROID}
method ArgsToString(arr: array of Object): array of String;
begin
  if length(arr) = 0 then exit [];
  result := new String[arr.length];
  for i: Integer := 0 to arr.length -1 do begin
    result[i] := arr[i]:toString();
  end;
end;

method BindArgs(st: android.database.sqlite.SQLiteStatement; aArgs: array of Object);
begin
  for i: Integer := 0 to length(aArgs) -1 do begin
    var val := aArgs[i];
    if val = nil then
      st.bindNull(i + 1)
    else if val is Double then
      st.bindDouble(i + 1, Double(val))
    else if val is Single then
      st.bindDouble(i + 1, Single(val))
    else if val is Int64 then
      st.bindLong(i + 1, Int64(val))
    else if val is Int64 then
      st.bindLong(i + 1, Int64(val))
    else if val is array of SByte then
      st.bindBlob(i + 1, array of SByte(val))
    else
      st.bindString(i + 1, val.toString);
  end;
end;
{$ENDIF}

{$IFDEF ECHOES or COCOA}
constructor SQLiteQueryResult(aDB, aRes: Int64);
begin
  fDB := aDB;
  fRes := aRes;
end;
{$ENDIF}



method SQLiteQueryResult.Close;
begin
  {$IFDEF COOPER}
  mapped.Close();
  {$ELSEIF ECHOES}
  if fRes <> nil then
    sqlite3_finalize(fRes);
  fRes := nil;
  {$ELSEIF NOUGAT}
  if fRes <> IntPtr(0) then
    sqlite3_finalize(^sqlite3_stmt(fRes));
  fRes := IntPtr(0);
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

{$IFDEF COCOA}finalizer SQLiteQueryResult;
begin
  Close;
end;
{$ENDIF}

method SQLiteQueryResult.Next: Boolean;
begin
  {$IFDEF PUREJAVA}
  exit mapped.next;
  {$ELSEIF ECHOES}
  var res := sqlite3_step(fRes);
  if res = SQLITE_ROW then exit true;
  if res = SQLITE_DONE then exit false;

  CheckSQLiteResultAndRaiseException(fDB, fRes);
  exit false; // unreachable
  {$ELSEIF COCOA}

  var res := sqlite3_step(^sqlite3_stmt(fRes));
  if res = SQLITE_ROW then exit true;
  if res = SQLITE_DONE then exit false;

  CheckSQLiteResultAndRaiseException(fDB, fRes);
  exit false; // unreachable
  {$ELSEIF ANDROID}
  exit mapped.moveToNext;
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteQueryResult.GetInt32(aIndex: Integer): nullable Integer;
begin
  {$IFDEF PUREJAVA}
  exit if mapped.getObject(1 + aIndex) = nil then nil else nullable Integer(mapped.GetInt32(1 + aIndex));
  {$ELSEIF ECHOES}
  if sqlite3_column_type(fRes, aIndex) = SQLITE_NULL then exit nil;
  exit sqlite3_column_int(fRes, aIndex);
  {$ELSEIF COCOA}
  if sqlite3_column_type(^sqlite3_stmt(fRes), aIndex) = SQLITE_NULL then exit nil;
  exit sqlite3_column_int(^sqlite3_stmt(fRes), aIndex);
  {$ELSEIF ANDROID}
  exit if mapped.isNull(aIndex) then nil else nullable Integer(mapped.GetInt32(aIndex));
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteQueryResult.GetInt64(aIndex: Integer): nullable Int64;
begin
  {$IFDEF PUREJAVA}
  exit if mapped.getObject(1 + aIndex) = nil then nil else nullable Int64(mapped.getLong(1 + aIndex));
  {$ELSEIF ECHOES}
  if sqlite3_column_type(fRes, aIndex) = SQLITE_NULL then exit nil;
  exit sqlite3_column_int64(fRes, aIndex);
  {$ELSEIF COCOA}
  if sqlite3_column_type(^sqlite3_stmt(fRes), aIndex) = SQLITE_NULL then exit nil;
  exit sqlite3_column_int64(^sqlite3_stmt(fRes), aIndex);
  {$ELSEIF ANDROID}
  exit if mapped.isNull(aIndex) then nil else nullable Int64(mapped.getLong(aIndex));
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteQueryResult.GetDouble(aIndex: Integer): nullable Double;
begin
  {$IFDEF PUREJAVA}
  exit if mapped.getObject(1 + aIndex) = nil then nil else nullable Double(mapped.getDouble(1 + aIndex));
  {$ELSEIF ECHOES}
  if sqlite3_column_type(fRes, aIndex) = SQLITE_NULL then exit nil;
  exit sqlite3_column_double(fRes, aIndex);
  {$ELSEIF COCOA}
  if sqlite3_column_type(^sqlite3_stmt(fRes), aIndex) = SQLITE_NULL then exit nil;
  exit sqlite3_column_double(^sqlite3_stmt(fRes), aIndex);
  {$ELSEIF ANDROID}
  exit if mapped.isNull(aIndex) then nil else nullable Double(mapped.getDouble(aIndex));
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteQueryResult.GetBytes(aIndex: Integer): array of {$IFDEF JAVA}SByte{$ELSE}Byte{$ENDIF};
begin
  {$IFDEF PUREJAVA}
  exit mapped.getBytes(1 + aIndex);
  {$ELSEIF ECHOES}
  var data: IntPtr := sqlite3_column_blob(fRes, aIndex);
  if data = IntPtr.Zero then exit nil;
  var n: array of Byte := new Byte[sqlite3_column_bytes(fRes, aIndex)];
  System.Runtime.InteropServices.Marshal.&Copy(data, n, 0, n.Length);
  exit n;
  {$ELSEIF COCOA}
  var data := sqlite3_column_blob(^sqlite3_stmt(fRes), aIndex);
  if data = nil then exit nil;
  var n: array of Byte := new Byte[sqlite3_column_bytes(^sqlite3_stmt(fRes), aIndex)];
  memcpy(@n[0], data, length(n));
  exit n;
  {$ELSEIF ANDROID}
  exit mapped.getBlob(aIndex);
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteQueryResult.GetString(aIndex: Integer): String;
begin
  {$IFDEF PUREJAVA}
  exit mapped.getString(1 + aIndex);
  {$ELSEIF ECHOES}
  if sqlite3_column_type(fRes, aIndex) = SQLITE_NULL then exit nil;

  exit System.Runtime.InteropServices.Marshal.PtrToStringUni(sqlite3_column_text16(fRes, aIndex));
  {$ELSEIF COCOA}
  if sqlite3_column_type(^sqlite3_stmt(fRes), aIndex) = SQLITE_NULL then exit nil;

  var p: ^unichar := ^unichar(sqlite3_column_text16(^sqlite3_stmt(fRes), aIndex));
  var plen := 0;
  while p[plen] <> #0 do inc(plen);
  exit new NSString withCharacters(p) length(plen);
  {$ELSEIF ANDROID}
  exit mapped.getString(aIndex);
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteQueryResult.GetInt32(aName: String): nullable Integer;
begin
  result := GetInt32(ColumnIndex[aName]);
end;

method SQLiteQueryResult.GetInt64(aName: String): nullable Int64;
begin
  result := GetInt64(ColumnIndex[aName]);
end;

method SQLiteQueryResult.GetDouble(aName: String): nullable Double;
begin
  result := GetDouble(ColumnIndex[aName]);
end;

method SQLiteQueryResult.GetBytes(aName: String): array of {$IFDEF JAVA}SByte{$ELSE}Byte{$ENDIF};
begin
  result := GetBytes(ColumnIndex[aName]);
end;

method SQLiteQueryResult.GetString(aName: String): String;
begin
  result := GetString(ColumnIndex[aName]);
end;

method SQLiteQueryResult.get_IsNull(aIndex: Integer): Boolean;
begin
  {$IFDEF PUREJAVA}
  exit mapped.getObject(aIndex) = nil;
  {$ELSEIF ECHOES}
  exit sqlite3_column_type(fRes, aIndex) = SQLITE_NULL;
  {$ELSEIF COCOA}
  exit sqlite3_column_type(^sqlite3_stmt(fRes), aIndex) = SQLITE_NULL;
  {$ELSEIF ANDROID}
  exit mapped.isNull(aIndex);
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;


method SQLiteQueryResult.get_ColumnCount: Integer;
begin
  {$IFDEF PUREJAVA}
  exit mapped.getMetaData().ColumnCount;
  {$ELSEIF ECHOES}
  exit sqlite3_column_count(fRes)
  {$ELSEIF COCOA}
  exit sqlite3_column_count(^sqlite3_stmt(fRes))
  {$ELSEIF ANDROID}
  exit mapped.ColumnCount;
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteQueryResult.get_ColumnName(aIndex: Integer): String;
begin
  {$IFDEF PUREJAVA}
  exit mapped.getMetaData().getColumnName(1 + aIndex);
  {$ELSEIF ECHOES}
  exit System.Runtime.InteropServices.Marshal.PtrToStringUni(sqlite3_column_name16(fRes, aIndex));
  {$ELSEIF COCOA}
  exit new NSString withCstring(^AnsiChar(sqlite3_column_name(^sqlite3_stmt(fRes), aIndex)) ) encoding( {$IFDEF OSX}NSStringEncoding.NSUTF8StringEncoding{$ELSE}NSStringEncoding.NSUTF16StringEncoding{$ENDIF});
  {$ELSEIF ANDROID}
  exit mapped.ColumnName[aIndex];
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;

method SQLiteQueryResult.get_ColumnIndex(aName: String): Integer;
begin
  {$IFDEF PUREJAVA}
  raise new SQLException('Column index not supported');
  {$ELSEIF ECHOES}
  if fNames = nil then begin
    fNames := new System.Collections.Generic.Dictionary<String, Integer>;
    for i: Integer := 0 to ColumnCount -1 do
      fNames[ColumnName[i]] := i;
  end;
  fNames.TryGetValue(aName, out result);
  {$ELSEIF COCOA}
  if fNames = nil then begin
    fNames := new NSMutableDictionary;
    for i: Integer := 0 to ColumnCount -1 do
      fNames[ColumnName[i]] := i;
  end;
  var lVal := fNames[aName];
  if lVal = nil then exit -1;
  exit Integer(lVal);
  {$ELSEIF ANDROID}
  exit mapped.ColumnIndex[aName];
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;




{$IFDEF ECHOES or COCOA}

constructor SQLiteException(s: String);
begin
  {$IFDEF COCOA}
  inherited constructor withName('SQLite') reason(s) userInfo(nil);
  {$ELSE}
  inherited constructor(s);
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF PUREJAVA}
class method SetParameters(st: PreparedStatement; aValues: array of Object);
begin
  for i: Integer := 0 to length(aValues) -1 do
    st.setObject(i+1, aValues[i])
end;

class method ExecuteAndGetLastInsertId(st: PreparedStatement): Int64;
begin
  st.executeUpdate;
  var key := st.getGeneratedKeys;
  if (key = nil) or (key.getMetaData.ColumnCount <> 1) then exit ;
  exit  key.getLong(1)
end;
{$ENDIF}
end.