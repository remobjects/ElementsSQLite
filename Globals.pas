namespace RemObjects.Elements.RTL.SQLite;

{$IF COCOA}
uses
  libsqlite3,
  Foundation;
{$ENDIF}

{$IFDEF ECHOES}
const SQLITE_INTEGER: Integer = 1;
const SQLITE_FLOAT: Integer = 2;
const SQLITE_BLOB: Integer = 4;
const SQLITE_NULL: Integer = 5;
const SQLITE3_TEXT: Integer = 3;
/// SQLITE_OK -> 0
const SQLITE_OK: Integer = 0;
/// SQLITE_ERROR -> 1
const SQLITE_ERROR: Integer = 1;
/// SQLITE_INTERNAL -> 2
const SQLITE_INTERNAL: Integer = 2;
/// SQLITE_PERM -> 3
const SQLITE_PERM: Integer = 3;
/// SQLITE_ABORT -> 4
const SQLITE_ABORT: Integer = 4;
/// SQLITE_BUSY -> 5
const SQLITE_BUSY: Integer = 5;
/// SQLITE_LOCKED -> 6
const SQLITE_LOCKED: Integer = 6;
/// SQLITE_NOMEM -> 7
const SQLITE_NOMEM: Integer = 7;
/// SQLITE_READONLY -> 8
const SQLITE_READONLY: Integer = 8;
/// SQLITE_INTERRUPT -> 9
const SQLITE_INTERRUPT: Integer = 9;
/// SQLITE_IOERR -> 10
const SQLITE_IOERR: Integer = 10;
/// SQLITE_CORRUPT -> 11
const SQLITE_CORRUPT: Integer = 11;
/// SQLITE_NOTFOUND -> 12
const SQLITE_NOTFOUND: Integer = 12;
/// SQLITE_FULL -> 13
const SQLITE_FULL: Integer = 13;
/// SQLITE_CANTOPEN -> 14
const SQLITE_CANTOPEN: Integer = 14;
/// SQLITE_PROTOCOL -> 15
const SQLITE_PROTOCOL: Integer = 15;
/// SQLITE_EMPTY -> 16
const SQLITE_EMPTY: Integer = 16;
/// SQLITE_SCHEMA -> 17
const SQLITE_SCHEMA: Integer = 17;
/// SQLITE_TOOBIG -> 18
const SQLITE_TOOBIG: Integer = 18;
/// SQLITE_CONSTRAINT -> 19
const SQLITE_CONSTRAINT: Integer = 19;
/// SQLITE_MISMATCH -> 20
const SQLITE_MISMATCH: Integer = 20;
/// SQLITE_MISUSE -> 21
const SQLITE_MISUSE: Integer = 21;
/// SQLITE_NOLFS -> 22
const SQLITE_NOLFS: Integer = 22;
/// SQLITE_AUTH -> 23
const SQLITE_AUTH: Integer = 23;
/// SQLITE_FORMAT -> 24
const SQLITE_FORMAT: Integer = 24;
/// SQLITE_RANGE -> 25
const SQLITE_RANGE: Integer = 25;
/// SQLITE_NOTADB -> 26
const SQLITE_NOTADB: Integer = 26;
/// SQLITE_NOTICE -> 27
const SQLITE_NOTICE: Integer = 27;
/// SQLITE_WARNING -> 28
const SQLITE_WARNING: Integer = 28;
/// SQLITE_ROW -> 100
const SQLITE_ROW: Integer = 100;
/// SQLITE_DONE -> 101
const SQLITE_DONE: Integer = 101;
/// SQLITE_OPEN_READONLY -> 0x00000001
const SQLITE_OPEN_READONLY: Integer = 1;
/// SQLITE_OPEN_READWRITE -> 0x00000002
const SQLITE_OPEN_READWRITE: Integer = 2;
/// SQLITE_OPEN_CREATE -> 0x00000004
const SQLITE_OPEN_CREATE: Integer = 4;
/// SQLITE_OPEN_DELETEONCLOSE -> 0x00000008
const SQLITE_OPEN_DELETEONCLOSE: Integer = 8;
/// SQLITE_OPEN_EXCLUSIVE -> 0x00000010
const SQLITE_OPEN_EXCLUSIVE: Integer = 16;
/// SQLITE_OPEN_AUTOPROXY -> 0x00000020
const SQLITE_OPEN_AUTOPROXY: Integer = 32;
/// SQLITE_OPEN_URI -> 0x00000040
const SQLITE_OPEN_URI: Integer = 64;
/// SQLITE_OPEN_MEMORY -> 0x00000080
const SQLITE_OPEN_MEMORY: Integer = 128;
/// SQLITE_OPEN_MAIN_DB -> 0x00000100
const SQLITE_OPEN_MAIN_DB: Integer = 256;
/// SQLITE_OPEN_TEMP_DB -> 0x00000200
const SQLITE_OPEN_TEMP_DB: Integer = 512;
/// SQLITE_OPEN_TRANSIENT_DB -> 0x00000400
const SQLITE_OPEN_TRANSIENT_DB: Integer = 1024;
/// SQLITE_OPEN_MAIN_JOURNAL -> 0x00000800
const SQLITE_OPEN_MAIN_JOURNAL: Integer = 2048;
/// SQLITE_OPEN_TEMP_JOURNAL -> 0x00001000
const SQLITE_OPEN_TEMP_JOURNAL: Integer = 4096;
/// SQLITE_OPEN_SUBJOURNAL -> 0x00002000
const SQLITE_OPEN_SUBJOURNAL: Integer = 8192;
/// SQLITE_OPEN_MASTER_JOURNAL -> 0x00004000
const SQLITE_OPEN_MASTER_JOURNAL: Integer = 16384;
/// SQLITE_OPEN_NOMUTEX -> 0x00008000
const SQLITE_OPEN_NOMUTEX: Integer = 32768;
/// SQLITE_OPEN_FULLMUTEX -> 0x00010000
const SQLITE_OPEN_FULLMUTEX: Integer = 65536;
/// SQLITE_OPEN_SHAREDCACHE -> 0x00020000
const SQLITE_OPEN_SHAREDCACHE: Integer = 131072;
/// SQLITE_OPEN_PRIVATECACHE -> 0x00040000
const SQLITE_OPEN_PRIVATECACHE: Integer = 262144;
/// SQLITE_OPEN_WAL -> 0x00080000
const SQLITE_OPEN_WAL: Integer = 524288;
/// SQLITE_IOCAP_ATOMIC -> 0x00000001

const DLLName : String = 'sqlite3.dll';
[System.Runtime.InteropServices.DllImport(DLLName,CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_close_v2(handle: IntPtr); external;
[System.Runtime.InteropServices.DllImport(DLLName,CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_last_insert_rowid(handle: IntPtr): Int64; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_changes(handle: IntPtr): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_open_v2(filename: String; var handle: IntPtr; &flags: Integer; zVfs: String): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Unicode)]
method sqlite3_prepare_v2(db: IntPtr; zSql: array of Byte; nByte: Integer; var ppStmt: IntPtr; pzTail: IntPtr): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_column_count(pStmt: IntPtr): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Unicode)]
method sqlite3_column_name16(stmt: IntPtr; N: Integer): IntPtr; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_bind_blob(st: IntPtr; idx: Integer; data: array of Byte; len: Integer; free: IntPtr): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_bind_double(st: IntPtr; idx: Integer; val: Double): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_bind_int(st: IntPtr; idx: Integer; val: Integer): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_bind_int64(st: IntPtr; idx: Integer; val: Int64): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_bind_null(st: IntPtr; idx: Integer): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Unicode)]
method sqlite3_bind_text16(st: IntPtr; idx: Integer; val: String; len: Integer; free: IntPtr): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_bind_parameter_count(st: IntPtr): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_bind_parameter_name(st: IntPtr; idx: Integer): IntPtr; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_bind_parameter_index(st: IntPtr; zName: String): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_step(st: IntPtr): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_column_blob(st: IntPtr; iCol: Integer): IntPtr; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_column_bytes(st: IntPtr; iCol: Integer): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Unicode)]
method sqlite3_column_bytes16(st: IntPtr; iCol: Integer): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_column_double(st: IntPtr; iCol: Integer): Double; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_column_int(st: IntPtr; iCol: Integer): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_column_int64(st: IntPtr; iCol: Integer): Int64; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Unicode)]
method sqlite3_column_text16(st: IntPtr; iCol: Integer): IntPtr; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_column_type(st: IntPtr; iCol: Integer): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_finalize(pStmt: IntPtr): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Ansi)]
method sqlite3_reset(pStmt: IntPtr): Integer; external;
[System.Runtime.InteropServices.DllImport(DLLName, CallingConvention := system.Runtime.InteropServices.CallingConvention.&Cdecl, CharSet := system.Runtime.InteropServices.CharSet.Unicode)]
method sqlite3_errmsg16(handle: IntPtr): IntPtr; external;
{$ENDIF}

{$IFDEF ECHOES OR COCOA}
method Throw(handle: IntPtr; res: Integer);
begin
  case res of
    0: begin
    end;
    SQLITE_ERROR: begin
      {$IFDEF ECHOES}
      if handle = IntPtr.Zero then
        raise new SQLiteException('SQL error or missing database ');
      raise new SQLiteException(System.Runtime.InteropServices.Marshal.PtrToStringUni(sqlite3_errmsg16(handle)));
      {$ELSE}
      if handle = IntPtr(nil) then
        raise new SQLiteException('SQL error or missing database ');
      var err := ^Char(sqlite3_errmsg16(^sqlite3(handle)));
      var plen := 0;
      while err[plen] <> #0 do inc(plen);

      var str := NSString.stringWithCharacters(err) length(plen);
      raise new SQLiteException(str);
      {$ENDIF}
    end;
    SQLITE_INTERNAL: begin
      raise new SQLiteException('Internal logic error in SQLite ');
    end;
    SQLITE_PERM: begin
      raise new SQLiteException('Access permission denied ');
    end;
    SQLITE_ABORT: begin
      raise new SQLiteException('Callback routine requested an abort ');
    end;
    SQLITE_BUSY: begin
      raise new SQLiteException('The database file is locked ');
    end;
    SQLITE_LOCKED: begin
      raise new SQLiteException('A table in the database is locked ');
    end;
    SQLITE_NOMEM: begin
      raise new SQLiteException('A malloc() failed ');
    end;
    SQLITE_READONLY: begin
      raise new SQLiteException('Attempt to write a readonly database ');
    end;
    SQLITE_INTERRUPT: begin
      raise new SQLiteException('Operation terminated by sqlite3_interrupt()');
    end;
    SQLITE_IOERR: begin
      raise new SQLiteException('Some kind of disk I/O error occurred ');
    end;
    SQLITE_CORRUPT: begin
      raise new SQLiteException('The database disk image is malformed ');
    end;
    SQLITE_NOTFOUND: begin
      raise new SQLiteException('Unknown opcode in sqlite3_file_control() ');
    end;
    SQLITE_FULL: begin
      raise new SQLiteException('Insertion failed because database is full ');
    end;
    SQLITE_CANTOPEN: begin
      raise new SQLiteException('Unable to open the database file ');
    end;
    SQLITE_PROTOCOL: begin
      raise new SQLiteException('Database lock protocol error ');
    end;
    SQLITE_EMPTY: begin
      raise new SQLiteException('Database is empty ');
    end;
    SQLITE_SCHEMA: begin
      raise new SQLiteException('The database schema changed ');
    end;
    SQLITE_TOOBIG: begin
      raise new SQLiteException('String or BLOB exceeds size limit ');
    end;
    SQLITE_CONSTRAINT: begin
      raise new SQLiteException('Abort due to constraint violation ');
    end;
    SQLITE_MISMATCH: begin
      raise new SQLiteException('Data type mismatch ');
    end;
    SQLITE_MISUSE: begin
      raise new SQLiteException('Library used incorrectly ');
    end;
    SQLITE_NOLFS: begin
      raise new SQLiteException('Uses OS features not supported on host ');
    end;
    SQLITE_AUTH: begin
      raise new SQLiteException('Authorization denied ');
    end;
    SQLITE_FORMAT: begin
      raise new SQLiteException('Auxiliary database format error ');
    end;
    SQLITE_RANGE: begin
      raise new SQLiteException('2nd parameter to sqlite3_bind out of range ');
    end;
    SQLITE_NOTADB: begin
      raise new SQLiteException('File opened that is not a database file ');
    end;
    27: begin
      raise new SQLiteException('Notifications from sqlite3_log() ');
    end;
    28: begin
      raise new SQLiteException('Warnings from sqlite3_log() ');
    end;
    SQLITE_ROW: begin
      raise new SQLiteException('sqlite3_step() has another row ready ');
    end;
    SQLITE_DONE: begin
      raise new SQLiteException('sqlite3_step() has finished executing ');
    end;
    else begin
      raise new SQLiteException('unknown error');
    end;
  end;
end;
{$ENDIF}

end.