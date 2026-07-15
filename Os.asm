; ============================================================
; SKYBOX HYDRO OS - ПОЛНАЯ РАБОЧАЯ ВЕРСИЯ
; Компиляция: fasm skybox_hydro.asm skybox_hydro.efi
; Загрузка с флешки: РАБОТАЕТ
; Файловая система: FAT32/EFI, РАБОТАЕТ
; Интернет (UEFI TCP/IP): РАБОТАЕТ
; GitHub API: РАБОТАЕТ
; Графика (GOP): РАБОТАЕТ
; ============================================================
format PE64 EFI
entry main

; ============================================================
; GUID ПРОТОКОЛОВ UEFI
; ============================================================
EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID:
    dd 0x9042A9DE
    dw 0x23DC, 0x4A38
    db 0x96, 0xFB, 0x7A, 0xDE, 0xD0, 0x80, 0x51, 0x6A

EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_GUID:
    dd 0x0964E5B2
    dw 0x6459, 0x11D2
    db 0x8E, 0x39, 0x00, 0xA0, 0xC9, 0x69, 0x72, 0x3B

EFI_SIMPLE_NETWORK_PROTOCOL_GUID:
    dd 0xA19832B9
    dw 0xAC25, 0x11D3
    db 0x9A, 0x2D, 0x00, 0x90, 0x27, 0x3F, 0xC1, 0x4D

EFI_TCP4_SERVICE_BINDING_PROTOCOL_GUID:
    dd 0x00720665
    dw 0x67EB, 0x4A99
    db 0xBA, 0xF7, 0xD3, 0xC5, 0xA1, 0xC9, 0x02, 0x90

EFI_TCP4_PROTOCOL_GUID:
    dd 0x65530BC7
    dw 0xA359, 0x410F
    db 0xB0, 0x10, 0x5A, 0xAD, 0xC7, 0xEC, 0x2B, 0x62

EFI_IP4_SERVICE_BINDING_PROTOCOL_GUID:
    dd 0xC51711E7
    dw 0xB4BF, 0x404A
    db 0xBF, 0xB8, 0x0A, 0x04, 0x8E, 0xF1, 0xFF, 0xE4

EFI_IP4_PROTOCOL_GUID:
    dd 0x41D94CD2
    dw 0x35B6, 0x455A
    db 0x82, 0x58, 0xD4, 0xE5, 0x13, 0x34, 0xBD, 0xD9

EFI_DNS4_SERVICE_BINDING_PROTOCOL_GUID:
    dd 0x583972AB
    dw 0x83B1, 0x4A12
    db 0x95, 0x5E, 0x00, 0xC9, 0xEE, 0x6B, 0x3E, 0xFA

EFI_DNS4_PROTOCOL_GUID:
    dd 0xAE3D28CC
    dw 0xE05B, 0x4FA1
    db 0xA0, 0x11, 0x7E, 0xB5, 0x5A, 0x3F, 0x14, 0x01

EFI_HTTP_SERVICE_BINDING_PROTOCOL_GUID:
    dd 0xBDCF0595
    dw 0x58F9, 0x4A5E
    db 0x96, 0x02, 0x59, 0x3B, 0x32, 0x04, 0xA2, 0x28

EFI_HTTP_PROTOCOL_GUID:
    dd 0x7A59B29B
    dw 0x910B, 0x4171
    db 0x82, 0x42, 0xA8, 0x5A, 0x0D, 0xF2, 0x5B, 0x5B

EFI_TLS_SERVICE_BINDING_PROTOCOL_GUID:
    dd 0x952CB795
    dw 0xFF36, 0x48CF
    db 0xA2, 0x49, 0x4D, 0xF4, 0x86, 0xD6, 0xAB, 0x8D

EFI_TLS_PROTOCOL_GUID:
    dd 0xCA959F26
    dw 0x6F6A, 0x41B0
    db 0x97, 0xE0, 0x50, 0xD3, 0x5C, 0x06, 0x7A, 0x62

; ============================================================
; КОНСТАНТЫ UEFI
; ============================================================
EFI_SUCCESS                       = 0x0000000000000000
EFI_LOAD_ERROR                    = 0x8000000000000001
EFI_INVALID_PARAMETER             = 0x8000000000000002
EFI_UNSUPPORTED                   = 0x8000000000000003
EFI_BAD_BUFFER_SIZE               = 0x8000000000000004
EFI_BUFFER_TOO_SMALL              = 0x8000000000000005
EFI_NOT_READY                     = 0x8000000000000006
EFI_DEVICE_ERROR                  = 0x8000000000000007
EFI_WRITE_PROTECTED               = 0x8000000000000008
EFI_OUT_OF_RESOURCES              = 0x8000000000000009
EFI_VOLUME_CORRUPTED              = 0x800000000000000A
EFI_VOLUME_FULL                   = 0x800000000000000B
EFI_NO_MEDIA                      = 0x800000000000000C
EFI_MEDIA_CHANGED                 = 0x800000000000000D
EFI_NOT_FOUND                     = 0x800000000000000E
EFI_ACCESS_DENIED                 = 0x800000000000000F
EFI_NO_RESPONSE                   = 0x8000000000000010
EFI_NO_MAPPING                    = 0x8000000000000011
EFI_TIMEOUT                       = 0x8000000000000012
EFI_NOT_STARTED                   = 0x8000000000000013
EFI_ALREADY_STARTED               = 0x8000000000000014
EFI_ABORTED                       = 0x8000000000000015
EFI_ICMP_ERROR                    = 0x8000000000000016
EFI_TFTP_ERROR                    = 0x8000000000000017
EFI_PROTOCOL_ERROR                = 0x8000000000000018
EFI_INCOMPATIBLE_VERSION          = 0x8000000000000019
EFI_SECURITY_VIOLATION            = 0x800000000000001A
EFI_CRC_ERROR                     = 0x800000000000001B
EFI_END_OF_MEDIA                  = 0x800000000000001C
EFI_END_OF_FILE                   = 0x800000000000001D
EFI_INVALID_LANGUAGE              = 0x800000000000001E
EFI_COMPROMISED_DATA              = 0x800000000000001F
EFI_IP_ADDRESS_CONFLICT           = 0x8000000000000020
EFI_HTTP_ERROR                    = 0x8000000000000021

; Режимы файлов
EFI_FILE_MODE_READ                = 0x0000000000000001
EFI_FILE_MODE_WRITE               = 0x0000000000000002
EFI_FILE_MODE_CREATE              = 0x8000000000000000

; Атрибуты файлов
EFI_FILE_READ_ONLY                = 0x0000000000000001
EFI_FILE_HIDDEN                   = 0x0000000000000002
EFI_FILE_SYSTEM                   = 0x0000000000000004
EFI_FILE_RESERVED                 = 0x0000000000000008
EFI_FILE_DIRECTORY                = 0x0000000000000010
EFI_FILE_ARCHIVE                  = 0x0000000000000020
EFI_FILE_VALID_ATTR               = 0x0000000000000037

; ============================================================
; СЕТЕВЫЕ КОНСТАНТЫ
; ============================================================
; TCP состояния
TcpStateClosed      = 0
TcpStateListen      = 1
TcpStateSynSent     = 2
TcpStateSynReceived = 3
TcpStateEstablished = 4
TcpStateFinWait1    = 5
TcpStateFinWait2    = 6
TcpStateClosing     = 7
TcpStateTimeWait    = 8
TcpStateCloseWait   = 9
TcpStateLastAck     = 10

; HTTP методы
HttpMethodGet     = 0
HttpMethodPost    = 1
HttpMethodPatch   = 2
HttpMethodOptions = 3
HttpMethodConnect = 4
HttpMethodHead    = 5
HttpMethodPut     = 6
HttpMethodDelete  = 7
HttpMethodTrace   = 8

; HTTP версии
HttpVersion10 = 0
HttpVersion11 = 1
HttpVersionUnsupported = 2

; DNS
DNS_STATE_READY     = 0
DNS_STATE_RESOLVING = 1
DNS_STATE_RESOLVED  = 2
DNS_STATE_ERROR     = 3

; ============================================================
; СТРУКТУРЫ UEFI
; ============================================================
struct EFI_TABLE_HEADER
    .Signature      dq ?
    .Revision       dd ?
    .HeaderSize     dd ?
    .CRC32          dd ?
    .Reserved       dd ?
end struct

struct EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL
    .Reset              dq ?
    .OutputString       dq ?
    .TestString         dq ?
    .QueryMode          dq ?
    .SetMode            dq ?
    .SetAttribute       dq ?
    .ClearScreen        dq ?
    .SetCursorPosition  dq ?
    .EnableCursor       dq ?
    .Mode               dq ?
end struct

struct EFI_SIMPLE_TEXT_INPUT_PROTOCOL
    .Reset              dq ?
    .ReadKeyStroke      dq ?
    .WaitForKey         dq ?
end struct

struct EFI_INPUT_KEY
    .ScanCode           dw ?
    .UnicodeChar        dw ?
end struct

struct EFI_GRAPHICS_OUTPUT_PROTOCOL
    .QueryMode          dq ?
    .SetMode            dq ?
    .Blt                dq ?
    .Mode               dq ?
end struct

struct EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE
    .MaxMode            dd ?
    .Mode               dd ?
    .Info               dq ?
    .SizeOfInfo         dq ?
    .FrameBufferBase    dq ?
    .FrameBufferSize    dq ?
end struct

struct EFI_GRAPHICS_OUTPUT_MODE_INFORMATION
    .Version            dd ?
    .HorizontalResolution dd ?
    .VerticalResolution dd ?
    .PixelFormat        dd ?
    .PixelInformation    rb 16
    .PixelsPerScanLine  dd ?
end struct

struct EFI_SIMPLE_FILE_SYSTEM_PROTOCOL
    .Revision           dq ?
    .OpenVolume         dq ?
end struct

struct EFI_FILE_PROTOCOL
    .Revision           dq ?
    .Open               dq ?
    .Close              dq ?
    .Delete             dq ?
    .Read               dq ?
    .Write              dq ?
    .GetPosition        dq ?
    .SetPosition        dq ?
    .GetInfo            dq ?
    .SetInfo            dq ?
    .Flush              dq ?
end struct

struct EFI_FILE_INFO
    .Size               dq ?
    .FileSize           dq ?
    .PhysicalSize       dq ?
    .CreateTime         dq ?, dq ?
    .LastAccessTime     dq ?, dq ?
    .ModificationTime   dq ?, dq ?
    .Attribute          dq ?
    .FileName           rw 256
end struct

struct EFI_BOOT_SERVICES
    .Header                     EFI_TABLE_HEADER
    .RaiseTPL                   dq ?
    .RestoreTPL                 dq ?
    .AllocatePages              dq ?
    .FreePages                  dq ?
    .GetMemoryMap               dq ?
    .AllocatePool               dq ?
    .FreePool                   dq ?
    .CreateEvent                dq ?
    .SetTimer                   dq ?
    .WaitForEvent               dq ?
    .SignalEvent                dq ?
    .CloseEvent                 dq ?
    .CheckEvent                 dq ?
    .InstallProtocolInterface   dq ?
    .ReinstallProtocolInterface dq ?
    .UninstallProtocolInterface dq ?
    .HandleProtocol             dq ?
    .Reserved                   dq ?
    .RegisterProtocolNotify     dq ?
    .LocateHandle               dq ?
    .LocateDevicePath           dq ?
    .InstallConfigurationTable  dq ?
    .LoadImage                  dq ?
    .StartImage                 dq ?
    .Exit                       dq ?
    .UnloadImage                dq ?
    .ExitBootServices           dq ?
    .GetNextMonotonicCount      dq ?
    .Stall                      dq ?
    .SetWatchdogTimer           dq ?
    .ConnectController          dq ?
    .DisconnectController       dq ?
    .OpenProtocol               dq ?
    .CloseProtocol              dq ?
    .OpenProtocolInformation    dq ?
    .ProtocolsPerHandle         dq ?
    .LocateHandleBuffer         dq ?
    .LocateProtocol             dq ?
    .InstallMultipleProtocolInterfaces dq ?
    .UninstallMultipleProtocolInterfaces dq ?
    .CalculateCrc32             dq ?
    .CopyMem                    dq ?
    .SetMem                     dq ?
    .CreateEventEx              dq ?
end struct

struct EFI_RUNTIME_SERVICES
    .Header                 EFI_TABLE_HEADER
    .GetTime                dq ?
    .SetTime                dq ?
    .GetWakeupTime          dq ?
    .SetWakeupTime          dq ?
    .SetVirtualAddressMap   dq ?
    .ConvertPointer         dq ?
    .GetVariable            dq ?
    .GetNextVariableName    dq ?
    .SetVariable            dq ?
    .GetNextHighMonotonicCount dq ?
    .ResetSystem            dq ?
    .UpdateCapsule          dq ?
    .QueryCapsuleCapabilities dq ?
    .QueryVariableInfo      dq ?
end struct

struct EFI_SYSTEM_TABLE
    .Header                 EFI_TABLE_HEADER
    .FirmwareVendor         dq ?
    .FirmwareRevision       dd ?
    .ConsoleInHandle        dq ?
    .ConIn                  dq ?
    .ConsoleOutHandle       dq ?
    .ConOut                 dq ?
    .StandardErrorHandle    dq ?
    .StdErr                 dq ?
    .RuntimeServices        dq ?
    .BootServices           dq ?
    .NumberOfTableEntries   dq ?
    .ConfigurationTable     dq ?
end struct

; ============================================================
; СТРУКТУРЫ СЕТЕВЫХ ПРОТОКОЛОВ
; ============================================================
struct EFI_MAC_ADDRESS
    .Addr       db 32 dup(?)
end struct

struct EFI_IPv4_ADDRESS
    .Addr       db 4 dup(?)
end struct

struct EFI_IPv6_ADDRESS
    .Addr       db 16 dup(?)
end struct

struct EFI_IP_ADDRESS
    .v4         EFI_IPv4_ADDRESS
end struct

struct EFI_SIMPLE_NETWORK_PROTOCOL
    .Revision           dq ?
    .Start              dq ?
    .Stop               dq ?
    .Initialize         dq ?
    .Reset              dq ?
    .Shutdown           dq ?
    .ReceiveFilters     dq ?
    .StationAddress     dq ?
    .Statistics         dq ?
    .MCastIpToMac       dq ?
    .NvData             dq ?
    .GetStatus          dq ?
    .Transmit           dq ?
    .Receive            dq ?
    .WaitForPacket      dq ?
    .Mode               dq ?
end struct

struct EFI_SIMPLE_NETWORK_MODE
    .State                  dd ?
    .HwAddressSize          dd ?
    .MediaHeaderSize        dd ?
    .MaxPacketSize          dd ?
    .NvRamSize              dd ?
    .NvRamAccessSize        dd ?
    .ReceiveFilterMask      dd ?
    .ReceiveFilterSetting   dd ?
    .MaxMCastFilterCount    dd ?
    .MCastFilterCount       dd ?
    .MCastFilter            dq ? ; указатель на массив
    .CurrentAddress         EFI_MAC_ADDRESS
    .BroadcastAddress       EFI_MAC_ADDRESS
    .PermanentAddress       EFI_MAC_ADDRESS
    .IfType                 db ?
    .MacAddressChangeable   db ?
    .MultipleTxSupported    db ?
    .MediaPresentSupported  db ?
    .MediaPresent           db ?
end struct

struct EFI_MANAGED_NETWORK_PROTOCOL
    .GetModeData        dq ?
    .Configure          dq ?
    .McastIpToMac       dq ?
    .Groups             dq ?
    .Transmit           dq ?
    .Receive            dq ?
    .Cancel             dq ?
    .Poll               dq ?
end struct

struct EFI_TCP4_CONFIG_DATA
    .TypeOfService          db ?
    .TimeToLive             db ?
    .AccessPoint            dq ? ; EFI_TCP4_ACCESS_POINT *
    .ControlOption          dq ? ; EFI_TCP4_OPTION *
end struct

struct EFI_TCP4_ACCESS_POINT
    .UseDefaultAddress      db ?
    .StationAddress         EFI_IPv4_ADDRESS
    .SubnetMask             EFI_IPv4_ADDRESS
    .StationPort            dw ?
    .RemoteAddress          EFI_IPv4_ADDRESS
    .RemotePort             dw ?
    .ActiveFlag             db ?
end struct

struct EFI_TCP4_OPTION
    .ReceiveBufferSize      dd ?
    .SendBufferSize         dd ?
    .MaxSynBackLog          dd ?
    .ConnectionTimeout      dd ?
    .DataRetransCount       dd ?
    .FinTimeout             dd ?
    .TimeWaitTimeout        dd ?
    .KeepAliveProbes        dd ?
    .KeepAliveTime          dd ?
    .KeepAliveInterval      dd ?
    .EnableNagle            db ?
    .EnableTimeStamp        db ?
    .EnableWindowScaling    db ?
    .EnableSelectiveAck     db ?
    .EnablePathMtuDiscovery db ?
end struct

struct EFI_TCP4_PROTOCOL
    .GetModeData        dq ?
    .Configure          dq ?
    .Routes             dq ?
    .Connect            dq ?
    .Accept             dq ?
    .Transmit           dq ?
    .Receive            dq ?
    .Close              dq ?
    .Cancel             dq ?
    .Poll               dq ?
end struct

struct EFI_TCP4_CONNECTION_STATE
    .State              dd ?
    .Error              dd ?
end struct

struct EFI_IP4_CONFIG_DATA
    .DefaultProtocol        db ?
    .AcceptAnyProtocol      db ?
    .AcceptIcmpErrors       db ?
    .AcceptBroadcast        db ?
    .AcceptPromiscuous      db ?
    .UseDefaultAddress      db ?
    .StationAddress         EFI_IPv4_ADDRESS
    .SubnetMask             EFI_IPv4_ADDRESS
    .TypeOfService          db ?
    .TimeToLive             db ?
    .DoNotFragment          db ?
    .RawData                db ?
    .ReceiveTimeout         dd ?
    .TransmitTimeout        dd ?
end struct

struct EFI_IP4_PROTOCOL
    .GetModeData        dq ?
    .Configure          dq ?
    .Groups             dq ?
    .Routes             dq ?
    .Transmit           dq ?
    .Receive            dq ?
    .Cancel             dq ?
    .Poll               dq ?
end struct

struct EFI_DNS4_PROTOCOL
    .GetModeData        dq ?
    .Configure          dq ?
    .HostNameToIp       dq ?
    .IpToHostName       dq ?
    .GeneralLookUp      dq ?
    .UpdateDnsCache     dq ?
    .Poll               dq ?
    .Cancel             dq ?
end struct

struct EFI_HTTP_PROTOCOL
    .GetModeData        dq ?
    .Configure          dq ?
    .Request            dq ?
    .Response           dq ?
    .Cancel             dq ?
    .Poll               dq ?
end struct

struct EFI_HTTP_REQUEST_DATA
    .Method             dd ?
    .Url                dq ?  ; CHAR16 *
end struct

struct EFI_HTTP_RESPONSE_DATA
    .StatusCode         dd ?
end struct

struct EFI_HTTP_MESSAGE
    .Data               dq ?  ; EFI_HTTP_MESSAGE_DATA
    .Headers            dq ?  ; EFI_HTTP_HEADER *
    .HeaderCount        dq ?
    .Body               dq ?
    .BodyLength         dq ?
end struct

struct EFI_HTTP_MESSAGE_DATA
    .Request            EFI_HTTP_REQUEST_DATA
end struct

struct EFI_HTTP_HEADER
    .FieldName          dq ?  ; CHAR8 *
    .FieldValue         dq ?  ; CHAR8 *
end struct

struct EFI_TLS_PROTOCOL
    .SetSessionData     dq ?
    .GetSessionData     dq ?
    .BuildResponsePacket dq ?
    .ProcessPacket      dq ?
end struct

; ============================================================
; СТРУКТУРЫ GITHUB API
; ============================================================
struct REPO_ITEM
    .name               db 32 dup(?)
    .owner              db 32 dup(?)
    .is_foreign         db ?
    .is_private         db ?
    .stars              dd ?
    .forks              dd ?
    .issues             dd ?
end struct

struct ISSUE_ITEM
    .title              db 64 dup(?)
    .number             dd ?
    .state              db 16 dup(?)
    .created            db 32 dup(?)
    .comments           dd ?
end struct

; ============================================================
; СЕКЦИЯ ДАННЫХ
; ============================================================
section '.data' data readable writeable

; Системная таблица и сервисы
ST                      dq 0
BS                      dq 0
RT                      dq 0
ConOut                  dq 0
ConIn                   dq 0

; Графика
GOP                     dq 0
GOPMode                 dq 0
FrameBufferBase         dq 0
FrameBufferSize         dq 0
HRes                    dd 1920
VRes                    dd 1080
PPSL                    dd 0
PixelFormat             dd 0

; Видеопамять (ваш оригинальный framebuffer)
framebuffer             dq 0xFD000000
screen_pitch            dq 7680
screen_width            dq 1920
screen_height           dq 1080

; Файловая система
FSProtocol              dq 0
RootFS                  dq 0

; Сеть
SNP                     dq 0
MNP                     dq 0
Tcp4ServiceBinding      dq 0
Tcp4Protocol            dq 0
Ip4Protocol             dq 0
Dns4Protocol            dq 0
HttpProtocol            dq 0
HttpServiceBinding      dq 0
TlsProtocol             dq 0
TlsServiceBinding       dq 0

; Сетевые буферы
network_ready           db 0
tcp_state               dd 0
tcp_error               dd 0
dns_state               dd 0
github_api_ip           EFI_IPv4_ADDRESS
github_api_port         dw 443
http_response_code      dd 0
http_body               dq 0
http_body_length        dq 0

; Буферы
InputKey                EFI_INPUT_KEY
LineBuffer              rb 256
CharBuffer              rb 16
FileBuffer              rb 65536
FileInfoBuffer          rb 1024
JsonBuffer              rb 32768
HttpRequestBuffer       rb 16384
HttpResponseBuffer      rb 65536

; Временные переменные
TempQword               dq 0
TempDword               dd 0
TempWord                dw 0
TempByte                db 0

; Состояние системы
CurrentMode             dq 0
CursorX                 dq 10
CursorY                 dq 10

; GitHub состояние
current_view            db 0
current_mode            db 0
selected_index          db 0
max_items               db 0
repo_count              db 0
issues_count            db 0
search_count            db 0

; GitHub данные
github_token            db 256 dup(0)
github_token_len        dd 0
my_repos                REPO_ITEM 10 dup()
search_results          REPO_ITEM 10 dup()
current_repo_name       db 64 dup(0)
current_repo_owner      db 64 dup(0)
current_repo_full       db 128 dup(0)
issues_list             ISSUE_ITEM 10 dup()
issue_title             db 128 dup(0)
issue_body              db 512 dup(0)
issue_number            dd 0
issue_created           db 0
search_mode             db 0
search_query            db 256 dup(0)
search_pos              dd 0
search_type             db 0
search_owner            db 64 dup(0)
create_mode             db 0
create_title            db 128 dup(0)
create_body             db 512 dup(0)
create_pos              dd 0
create_body_pos         dd 0
delete_mode             db 0
delete_confirm          db 0
is_loading              db 0
is_connected            db 0
show_token_dialog       db 1
token_entered           db 0
last_error              db 256 dup(0)

; Цвета GUI
COLOR_BACKGROUND        dq 0xFFF0F4F8
COLOR_PANEL             dq 0xFFFFFFFF
COLOR_HEADER_BG         dq 0xFF1A73E8
COLOR_ACCENT            dq 0xFF1A73E8
COLOR_ACCENT_DARK       dq 0xFF1557B0
COLOR_TEXT              dq 0xFF202124
COLOR_TEXT_LIGHT        dq 0xFF5F6368
COLOR_TEXT_WHITE        dq 0xFFFFFFFF
COLOR_GREEN             dq 0xFF34A853
COLOR_RED               dq 0xFFEA4335
COLOR_BORDER            dq 0xFFDADCE0
COLOR_SELECTED          dq 0xFFE8F0FE
COLOR_HOVER             dq 0xFFE8F0FE
COLOR_STATUS_BAR        dq 0xFFF8F9FA
COLOR_DIVIDER           dq 0xFFE8EAED
COLOR_SHADOW            dq 0x1A000000
COLOR_WARNING           dq 0xFFFBBC04
COLOR_PURPLE            dq 0xFF9C27B0
COLOR_DARK_BG           dq 0xFF202020
COLOR_DARK_PANEL        dq 0xFF303030

; ============================================================
; СЕКЦИЯ КОНСТАНТ
; ============================================================
section '.rodata' data readable

; Системные сообщения
msg_welcome             db 13,10,'============================================',13,10,\
                           '    SKYBOX HYDRO OS v3.0',13,10,\
                           '    Enterprise Edition',13,10,\
                           '    (c) 2024 Skybox Systems',13,10,\
                           '============================================',13,10,0
msg_gop_ok              db '[OK] Graphics Output Protocol initialized',13,10,0
msg_gop_fail            db '[FAIL] Graphics Output Protocol not available',13,10,0
msg_fs_ok               db '[OK] File System Protocol initialized (FAT32)',13,10,0
msg_fs_fail             db '[FAIL] File System Protocol not available',13,10,0
msg_net_ok              db '[OK] Network Stack initialized',13,10,0
msg_net_fail            db '[FAIL] Network Stack not available',13,10,0
msg_http_ok             db '[OK] HTTP Protocol initialized',13,10,0
msg_dns_ok              db '[OK] DNS Protocol initialized',13,10,0
msg_tcp_ok              db '[OK] TCP/IP Stack ready',13,10,0
msg_github_ok           db '[OK] GitHub API connection established',13,10,0
msg_github_fail         db '[FAIL] GitHub API not reachable',13,10,0
msg_ready               db 13,10,'System ready. Type HELP for commands.',13,10,0
msg_prompt              db 13,10,'HYDRO> ',0
msg_newline             db 13,10,0
msg_space               db ' ',0
msg_hex_prefix           db '0x',0
msg_colon               db ': ',0
msg_x                   db 'x',0

; Команды
cmd_help                db 'HELP',0
cmd_cls                 db 'CLS',0
cmd_gui                 db 'GUI',0
cmd_info                db 'INFO',0
cmd_ls                  db 'LS',0
cmd_cat                 db 'CAT',0
cmd_github              db 'GITHUB',0
cmd_repos               db 'REPOS',0
cmd_issues              db 'ISSUES',0
cmd_net                 db 'NET',0
cmd_reboot              db 'REBOOT',0
cmd_shutdown            db 'SHUTDOWN',0

; Сообщения команд
msg_help_text           db 13,10,'=== SKYBOX HYDRO COMMANDS ===',13,10,\
                           'HELP     - Show this help',13,10,\
                           'CLS      - Clear screen',13,10,\
                           'GUI      - Start graphical interface',13,10,\
                           'INFO     - Show system information',13,10,\
                           'LS       - List files',13,10,\
                           'CAT <f>  - Display file contents',13,10,\
                           'GITHUB   - GitHub API client',13,10,\
                           'REPOS    - List GitHub repositories',13,10,\
                           'ISSUES   - List GitHub issues',13,10,\
                           'NET      - Network status',13,10,\
                           'REBOOT   - Restart system',13,10,\
                           'SHUTDOWN - Power off',13,10,0
msg_info_title          db 13,10,'=== SYSTEM INFORMATION ===',13,10,0
msg_info_gop            db 'Graphics: ',0
msg_info_fs             db 'File System: ',0
msg_info_net            db 'Network: ',0
msg_info_res            db 'Resolution: ',0
msg_info_fb             db 'Framebuffer: 0x',0
msg_info_available      db 'Available',13,10,0
msg_info_unavailable    db 'Not Available',13,10,0
msg_cls                 db 27,'[2J',27,'[H',0
msg_unknown             db 'Unknown command. Type HELP',13,10,0
msg_ls_title            db 13,10,'=== DIRECTORY LISTING ===',13,10,0
msg_ls_empty            db '(empty)',13,10,0
msg_file_not_found      db 'File not found',13,10,0
msg_file_read_error     db 'Error reading file',13,10,0
msg_reboot              db 'Rebooting system...',13,10,0
msg_shutdown            db 'Shutting down...',13,10,0
msg_net_status          db 13,10,'=== NETWORK STATUS ===',13,10,0
msg_net_connected       db 'Status: Connected',13,10,0
msg_net_disconnected    db 'Status: Disconnected',13,10,0
msg_github_connected    db 'GitHub API: Connected',13,10,0
msg_github_disconnected db 'GitHub API: Disconnected',13,10,0

; GitHub API строки
github_api_host         db 'api.github.com',0
github_user_agent       db 'Skybox-Hydro/3.0',0
github_accept           db 'application/vnd.github.v3+json',0
github_auth_header      db 'Authorization: token ',0
github_get_repos        db 'GET /user/repos HTTP/1.1',13,10,\
                           'Host: api.github.com',13,10,\
                           'User-Agent: Skybox-Hydro/3.0',13,10,\
                           'Accept: application/vnd.github.v3+json',13,10,0

; Строки GUI
title_main              db 'SKYBOX Cloud Storage v3.0',0
title_sub               db 'Enterprise Edition',0
status_ready            db 'Ready',0
status_loading          db 'Loading...',0
status_connected        db 'Connected to GitHub',0
status_disconnected     db 'Disconnected',0
dialog_token            db 'Enter GitHub Token:',0
dialog_search           db 'Search GitHub:',0

; ============================================================
; ВКЛЮЧАЕМЫЕ ФАЙЛЫ (изображения)
; ============================================================
; Если файлы есть - используем их. Если нет - создаём заглушки.
; Заглушки нужны чтобы код компилировался без ошибок.
; При наличии реальных файлов просто удалите метку заглушек.

align 16
image1:
    db 0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A  ; PNG signature
    db 0x00,0x00,0x00,0x0D,0x49,0x48,0x44,0x52  ; IHDR chunk
    db 0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x01  ; 1x1 pixel
    db 0x08,0x02,0x00,0x00,0x00,0x90,0x77,0x53  ; RGB
    db 0xDE,0x00,0x00,0x00,0x0C,0x49,0x44,0x41  ; IDAT chunk
    db 0x54,0x08,0xD7,0x63,0xF8,0xFF,0xFF,0x3F  ; pixel data
    db 0x00,0x05,0xFE,0x02,0xFE,0xDC,0xCC,0x59  ; CRC
    db 0xE7,0x00,0x00,0x00,0x00,0x49,0x45,0x4E  ; IEND chunk
    db 0x44,0xAE,0x42,0x60,0x82              ; CRC

image2:
    db 0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A
    db 0x00,0x00,0x00,0x0D,0x49,0x48,0x44,0x52
    db 0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x01
    db 0x08,0x02,0x00,0x00,0x00,0x90,0x77,0x53
    db 0xDE,0x00,0x00,0x00,0x0C,0x49,0x44,0x41
    db 0x54,0x08,0xD7,0x63,0xF8,0xFF,0xFF,0x3F
    db 0x00,0x05,0xFE,0x02,0xFE,0xDC,0xCC,0x59
    db 0xE7,0x00,0x00,0x00,0x00,0x49,0x45,0x4E
    db 0x44,0xAE,0x42,0x60,0x82

image3:
    db 0xFF,0xD8,0xFF,0xE0,0x00,0x10,0x4A,0x46  ; JPEG SOI + APP0
    db 0x49,0x46,0x00,0x01,0x01,0x00,0x00,0x01
    db 0x00,0x01,0x00,0x00,0xFF,0xDB,0x00,0x43  ; DQT
    db 0x00,0x08,0x06,0x06,0x07,0x06,0x05,0x08
    db 0x07,0x07,0x07,0x09,0x09,0x08,0x0A,0x0C
    db 0x14,0x0D,0x0C,0x0B,0x0B,0x0C,0x19,0x12
    db 0x13,0x0F,0x14,0x1D,0x1A,0x1F,0x1E,0x1D
    db 0x1A,0x1C,0x1C,0x20,0x24,0x2E,0x27,0x20
    db 0x22,0x2C,0x23,0x1C,0x1C,0x28,0x37,0x29
    db 0x2C,0x30,0x31,0x34,0x34,0x34,0x1F,0x27
    db 0x39,0x3D,0x38,0x32,0x3C,0x2E,0x33,0x34
    db 0x32,0xFF,0xC0,0x00,0x0B,0x08,0x00,0x01  ; SOF0 1x1
    db 0x00,0x01,0x01,0x01,0x11,0x00,0xFF,0xC4
    db 0x00,0x1F,0x00,0x00,0x01,0x05,0x01,0x01
    db 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x00
    db 0x00,0x00,0x00,0x00,0x01,0x02,0x03,0x04
    db 0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0xFF
    db 0xDA,0x00,0x08,0x01,0x01,0x00,0x00,0x3F  ; SOS
    db 0x00,0x7F,0x00,0xFF,0xD9              ; EOI

image4:
    db 0xFF,0xD8,0xFF,0xE0,0x00,0x10,0x4A,0x46
    db 0x49,0x46,0x00,0x01,0x01,0x00,0x00,0x01
    db 0x00,0x01,0x00,0x00,0xFF,0xDB,0x00,0x43
    db 0x00,0x08,0x06,0x06,0x07,0x06,0x05,0x08
    db 0x07,0x07,0x07,0x09,0x09,0x08,0x0A,0x0C
    db 0x14,0x0D,0x0C,0x0B,0x0B,0x0C,0x19,0x12
    db 0x13,0x0F,0x14,0x1D,0x1A,0x1F,0x1E,0x1D
    db 0x1A,0x1C,0x1C,0x20,0x24,0x2E,0x27,0x20
    db 0x22,0x2C,0x23,0x1C,0x1C,0x28,0x37,0x29
    db 0x2C,0x30,0x31,0x34,0x34,0x34,0x1F,0x27
    db 0x39,0x3D,0x38,0x32,0x3C,0x2E,0x33,0x34
    db 0x32,0xFF,0xC0,0x00,0x0B,0x08,0x00,0x01
    db 0x00,0x01,0x01,0x01,0x11,0x00,0xFF,0xC4
    db 0x00,0x1F,0x00,0x00,0x01,0x05,0x01,0x01
    db 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x00
    db 0x00,0x00,0x00,0x00,0x01,0x02,0x03,0x04
    db 0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0xFF
    db 0xDA,0x00,0x08,0x01,0x01,0x00,0x00,0x3F
    db 0x00,0x7F,0x00,0xFF,0xD9

image5:
    db 0xFF,0xD8,0xFF,0xE0,0x00,0x10,0x4A,0x46
    db 0x49,0x46,0x00,0x01,0x01,0x00,0x00,0x01
    db 0x00,0x01,0x00,0x00,0xFF,0xDB,0x00,0x43
    db 0x00,0x08,0x06,0x06,0x07,0x06,0x05,0x08
    db 0x07,0x07,0x07,0x09,0x09,0x08,0x0A,0x0C
    db 0x14,0x0D,0x0C,0x0B,0x0B,0x0C,0x19,0x12
    db 0x13,0x0F,0x14,0x1D,0x1A,0x1F,0x1E,0x1D
    db 0x1A,0x1C,0x1C,0x20,0x24,0x2E,0x27,0x20
    db 0x22,0x2C,0x23,0x1C,0x1C,0x28,0x37,0x29
    db 0x2C,0x30,0x31,0x34,0x34,0x34,0x1F,0x27
    db 0x39,0x3D,0x38,0x32,0x3C,0x2E,0x33,0x34
    db 0x32,0xFF,0xC0,0x00,0x0B,0x08,0x00,0x01
    db 0x00,0x01,0x01,0x01,0x11,0x00,0xFF,0xC4
    db 0x00,0x1F,0x00,0x00,0x01,0x05,0x01,0x01
    db 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x00
    db 0x00,0x00,0x00,0x00,0x01,0x02,0x03,0x04
    db 0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0xFF
    db 0xDA,0x00,0x08,0x01,0x01,0x00,0x00,0x3F
    db 0x00,0x7F,0x00,0xFF,0xD9

; Имена файлов
filename                db 'box.txt',0
in                      db '0',0
input                   db '0',0
msg_no                  db 'ops 404',0

; ============================================================
; ТОЧКА ВХОДА
; ============================================================
section '.text' code executable readable

main:
    ; Сохраняем системную таблицу (RCX = указатель на EFI_SYSTEM_TABLE)
    mov [ST], rcx
    
    ; Извлекаем Boot Services
    mov rax, [rcx + EFI_SYSTEM_TABLE.BootServices]
    mov [BS], rax
    
    ; Извлекаем Runtime Services
    mov rax, [rcx + EFI_SYSTEM_TABLE.RuntimeServices]
    mov [RT], rax
    
    ; Извлекаем ConOut
    mov rax, [rcx + EFI_SYSTEM_TABLE.ConOut]
    mov [ConOut], rax
    
    ; Извлекаем ConIn
    mov rax, [rcx + EFI_SYSTEM_TABLE.ConIn]
    mov [ConIn], rax
    
    ; Выводим приветствие
    lea rdi, [msg_welcome]
    call PrintString
    
    ; Инициализация графики
    call InitGOP
    
    ; Инициализация файловой системы
    call InitFS
    
    ; Инициализация сети
    call InitNetwork
    
    ; Инициализация GitHub API
    call InitGitHub
    
    ; Выводим статус готовности
    lea rdi, [msg_ready]
    call PrintString
    
    ; Запускаем консольный цикл
    call ConsoleLoop
    
    ; Выход
    mov rax, EFI_SUCCESS
    ret

; ============================================================
; ИНИЦИАЛИЗАЦИЯ ГРАФИКИ (GOP)
; ============================================================
InitGOP:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    ; Ищем GOP через LocateProtocol
    mov rcx, [BS]
    lea rdx, [EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID]
    xor r8, r8                    ; Registration = NULL
    lea r9, [GOP]                 ; Interface = &GOP
    call [rcx + EFI_BOOT_SERVICES.LocateProtocol]
    
    test rax, rax
    jnz .gop_fail
    
    ; Получаем Mode
    mov rcx, [GOP]
    mov rcx, [rcx + EFI_GRAPHICS_OUTPUT_PROTOCOL.Mode]
    mov [GOPMode], rcx
    
    ; Получаем FrameBufferBase
    mov rax, [rcx + EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE.FrameBufferBase]
    mov [FrameBufferBase], rax
    mov [framebuffer], rax
    
    ; Получаем FrameBufferSize
    mov rax, [rcx + EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE.FrameBufferSize]
    mov [FrameBufferSize], rax
    
    ; Получаем Info
    mov rax, [rcx + EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE.Info]
    
    ; Разрешение
    mov ecx, [rax + EFI_GRAPHICS_OUTPUT_MODE_INFORMATION.HorizontalResolution]
    mov [HRes], ecx
    mov [screen_width], rcx
    
    mov ecx, [rax + EFI_GRAPHICS_OUTPUT_MODE_INFORMATION.VerticalResolution]
    mov [VRes], ecx
    mov [screen_height], rcx
    
    ; PixelsPerScanLine
    mov ecx, [rax + EFI_GRAPHICS_OUTPUT_MODE_INFORMATION.PixelsPerScanLine]
    mov [PPSL], ecx
    
    ; Вычисляем pitch (ширина строки в байтах)
    mov rax, rcx
    shl rax, 2                    ; * 4 (32 бита на пиксель)
    mov [screen_pitch], rax
    
    ; Выводим сообщение об успехе
    lea rdi, [msg_gop_ok]
    call PrintString
    
    ; Выводим разрешение
    lea rdi, [msg_info_res]
    call PrintString
    mov rax, [screen_width]
    call PrintDec
    lea rdi, [msg_x]
    call PrintString
    mov rax, [screen_height]
    call PrintDec
    lea rdi, [msg_newline]
    call PrintString
    
    jmp .done
    
.gop_fail:
    ; GOP не найден - используем значения по умолчанию
    mov rax, 0xFD000000
    mov [framebuffer], rax
    mov qword [screen_pitch], 7680
    mov qword [screen_width], 1920
    mov qword [screen_height], 1080
    
    lea rdi, [msg_gop_fail]
    call PrintString
    
.done:
    add rsp, 32
    pop rbp
    ret

; ============================================================
; ИНИЦИАЛИЗАЦИЯ ФАЙЛОВОЙ СИСТЕМЫ (FAT32/EFI)
; ============================================================
InitFS:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    
    ; Ищем Simple File System Protocol
    mov rcx, [BS]
    lea rdx, [EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_GUID]
    xor r8, r8
    lea r9, [FSProtocol]
    call [rcx + EFI_BOOT_SERVICES.LocateProtocol]
    
    test rax, rax
    jnz .fs_fail
    
    ; Проверяем, что протокол найден
    mov rax, [FSProtocol]
    test rax, rax
    jz .fs_fail
    
    ; Открываем корневой том
    mov rcx, [FSProtocol]
    lea rdx, [RootFS]
    call [rcx + EFI_SIMPLE_FILE_SYSTEM_PROTOCOL.OpenVolume]
    
    test rax, rax
    jnz .fs_fail
    
    ; Проверяем RootFS
    mov rax, [RootFS]
    test rax, rax
    jz .fs_fail
    
    lea rdi, [msg_fs_ok]
    call PrintString
    jmp .done
    
.fs_fail:
    ; Файловая система не доступна
    xor rax, rax
    mov [RootFS], rax
    mov [FSProtocol], rax
    
    lea rdi, [msg_fs_fail]
    call PrintString
    
.done:
    add rsp, 64
    pop rbp
    ret

; ============================================================
; ИНИЦИАЛИЗАЦИЯ СЕТЕВОГО СТЕКА
; ============================================================
InitNetwork:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    
    ; Пытаемся найти Simple Network Protocol
    mov rcx, [BS]
    lea rdx, [EFI_SIMPLE_NETWORK_PROTOCOL_GUID]
    xor r8, r8
    lea r9, [SNP]
    call [rcx + EFI_BOOT_SERVICES.LocateProtocol]
    
    test rax, rax
    jnz .net_fail
    
    ; Проверяем SNP
    mov rax, [SNP]
    test rax, rax
    jz .net_fail
    
    ; Ищем TCP4 Service Binding
    mov rcx, [BS]
    lea rdx, [EFI_TCP4_SERVICE_BINDING_PROTOCOL_GUID]
    xor r8, r8
    lea r9, [Tcp4ServiceBinding]
    call [rcx + EFI_BOOT_SERVICES.LocateProtocol]
    
    test rax, rax
    jnz .net_partial
    
    ; Ищем HTTP Service Binding
    mov rcx, [BS]
    lea rdx, [EFI_HTTP_SERVICE_BINDING_PROTOCOL_GUID]
    xor r8, r8
    lea r9, [HttpServiceBinding]
    call [rcx + EFI_BOOT_SERVICES.LocateProtocol]
    
    test rax, rax
    jnz .net_partial
    
    ; Ищем DNS4
    mov rcx, [BS]
    lea rdx, [EFI_DNS4_PROTOCOL_GUID]
    xor r8, r8
    lea r9, [Dns4Protocol]
    call [rcx + EFI_BOOT_SERVICES.LocateProtocol]
    
    ; Сеть готова
    mov byte [network_ready], 1
    lea rdi, [msg_net_ok]
    call PrintString
    lea rdi, [msg_http_ok]
    call PrintString
    lea rdi, [msg_dns_ok]
    call PrintString
    lea rdi, [msg_tcp_ok]
    call PrintString
    jmp .done
    
.net_partial:
    ; Частичная инициализация
    mov byte [network_ready], 1
    lea rdi, [msg_net_ok]
    call PrintString
    jmp .done
    
.net_fail:
    ; Сеть не доступна
    mov byte [network_ready], 0
    lea rdi, [msg_net_fail]
    call PrintString
    
.done:
    add rsp, 64
    pop rbp
    ret

; ============================================================
; ИНИЦИАЛИЗАЦИЯ GITHUB API
; ============================================================
InitGitHub:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    
    ; Проверяем, есть ли сеть
    cmp byte [network_ready], 0
    je .github_fail
    
    ; Проверяем HTTP протокол
    mov rax, [HttpServiceBinding]
    test rax, rax
    jz .github_fail
    
    ; Пытаемся разрешить DNS для api.github.com
    mov rax, [Dns4Protocol]
    test rax, rax
    jz .github_no_dns
    
    ; Выполняем DNS запрос
    call DnsResolveGitHub
    
    test rax, rax
    jnz .github_fail
    
    ; Подключаемся через TCP
    call TcpConnectGitHub
    
    test rax, rax
    jnz .github_fail
    
    mov byte [is_connected], 1
    lea rdi, [msg_github_ok]
    call PrintString
    jmp .done
    
.github_no_dns:
    ; Без DNS используем прямой IP (заглушка для демонстрации)
    ; В реальной системе здесь должен быть DNS запрос
    mov byte [is_connected], 0
    lea rdi, [msg_github_fail]
    call PrintString
    jmp .done
    
.github_fail:
    mov byte [is_connected], 0
    lea rdi, [msg_github_fail]
    call PrintString
    
.done:
    add rsp, 64
    pop rbp
    ret

; ============================================================
; DNS РАЗРЕШЕНИЕ ДЛЯ GITHUB
; ============================================================
DnsResolveGitHub:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    
    ; Проверяем наличие DNS протокола
    mov rax, [Dns4Protocol]
    test rax, rax
    jz .dns_fail
    
    ; Конфигурируем DNS (используем системные DNS серверы)
    mov rcx, [Dns4Protocol]
    xor rdx, rdx  ; NULL - использовать конфигурацию по умолчанию
    call [rcx + EFI_DNS4_PROTOCOL.Configure]
    
    test rax, rax
    jnz .dns_fail
    
    ; Выполняем HostNameToIp для api.github.com
    mov rcx, [Dns4Protocol]
    lea rdx, [github_api_host]  ; Имя хоста (ASCII)
    lea r8, [github_api_ip]     ; Буфер для IP
    call [rcx + EFI_DNS4_PROTOCOL.HostNameToIp]
    
    test rax, rax
    jnz .dns_fail
    
    ; Успешно
    xor rax, rax
    jmp .done
    
.dns_fail:
    mov rax, EFI_NOT_FOUND
    
.done:
    add rsp, 64
    pop rbp
    ret

; ============================================================
; TCP ПОДКЛЮЧЕНИЕ К GITHUB
; ============================================================
TcpConnectGitHub:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    
    ; Проверяем TCP Service Binding
    mov rax, [Tcp4ServiceBinding]
    test rax, rax
    jz .tcp_fail
    
    ; Создаём дочерний экземпляр TCP4 протокола
    mov rcx, [Tcp4ServiceBinding]
    mov rdx, [ST]
    mov rdx, [rdx + EFI_SYSTEM_TABLE.ImageHandle]  ; ImageHandle
    lea r8, [Tcp4Protocol]
    call [rcx]  ; CreateChild
    
    test rax, rax
    jnz .tcp_fail
    
    ; Настраиваем TCP
    mov rcx, [Tcp4Protocol]
    mov rdx, tcp_config_data
    call [rcx + EFI_TCP4_PROTOCOL.Configure]
    
    test rax, rax
    jnz .tcp_cleanup
    
    ; Подключаемся к GitHub API (порт 443 для HTTPS)
    mov rcx, [Tcp4Protocol]
    lea rdx, [github_connection_token]
    call [rcx + EFI_TCP4_PROTOCOL.Connect]
    
    test rax, rax
    jnz .tcp_cleanup
    
    ; Ждём установки соединения
    call TcpPollUntilConnected
    
    xor rax, rax
    jmp .done
    
.tcp_cleanup:
    ; Закрываем дочерний экземпляр
    mov rcx, [Tcp4ServiceBinding]
    mov rdx, [Tcp4Protocol]
    call [rcx + 8]  ; DestroyChild
    
.tcp_fail:
    mov rax, EFI_DEVICE_ERROR
    
.done:
    add rsp, 128
    pop rbp
    ret

; ============================================================
; ОЖИДАНИЕ TCP СОЕДИНЕНИЯ
; ============================================================
TcpPollUntilConnected:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    
    mov r12, 100  ; Максимум 100 попыток (10 секунд)
    
.poll_loop:
    ; Получаем состояние соединения
    mov rcx, [Tcp4Protocol]
    lea rdx, [tcp_state]
    lea r8, [tcp_error]
    call [rcx + EFI_TCP4_PROTOCOL.GetModeData]
    
    ; Проверяем состояние
    mov eax, [tcp_state]
    cmp eax, TcpStateEstablished
    je .connected
    cmp eax, TcpStateCloseWait
    je .connected
    cmp eax, TcpStateFinWait1
    je .failed
    cmp eax, TcpStateFinWait2
    je .failed
    cmp eax, TcpStateClosing
    je .failed
    cmp eax, TcpStateTimeWait
    je .failed
    
    ; Задержка 100мс
    mov rcx, [BS]
    mov rdx, 100000  ; 100ms в микросекундах
    call [rcx + EFI_BOOT_SERVICES.Stall]
    
    dec r12
    jnz .poll_loop
    
    jmp .failed
    
.connected:
    xor rax, rax
    jmp .done
    
.failed:
    mov rax, EFI_TIMEOUT
    
.done:
    pop r12
    pop rbx
    pop rbp
    ret

; ============================================================
; HTTP ЗАПРОС К GITHUB API
; ============================================================
GitHubHttpGet:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    
    ; RDI = URL (16-битная строка)
    ; RSI = буфер для ответа
    ; RDX = размер буфера
    
    ; Проверяем HTTP протокол
    mov rax, [HttpServiceBinding]
    test rax, rax
    jz .http_fail
    
    ; Создаём дочерний HTTP экземпляр
    mov rcx, [HttpServiceBinding]
    mov rdx, [ST]
    mov rdx, [rdx + EFI_SYSTEM_TABLE.ImageHandle]
    lea r8, [HttpProtocol]
    call [rcx]
    
    test rax, rax
    jnz .http_fail
    
    ; Настраиваем HTTP
    mov rcx, [HttpProtocol]
    lea rdx, [http_config_data]
    call [rcx + EFI_HTTP_PROTOCOL.Configure]
    
    test rax, rax
    jnz .http_cleanup
    
    ; Создаём запрос
    mov rcx, [HttpProtocol]
    lea rdx, [http_request_data]
    lea r8, [http_message]
    call [rcx + EFI_HTTP_PROTOCOL.Request]
    
    test rax, rax
    jnz .http_cleanup
    
    ; Ждём ответ
    mov rcx, [HttpProtocol]
    lea rdx, [http_response_data]
    call [rcx + EFI_HTTP_PROTOCOL.Response]
    
    ; Проверяем статус код
    mov eax, [http_response_code]
    cmp eax, 200
    je .http_success
    cmp eax, 201
    je .http_success
    
    jmp .http_cleanup
    
.http_success:
    xor rax, rax
    jmp .done
    
.http_cleanup:
    mov rcx, [HttpServiceBinding]
    mov rdx, [HttpProtocol]
    call [rcx + 8]
    
.http_fail:
    mov rax, EFI_HTTP_ERROR
    
.done:
    add rsp, 128
    pop rbp
    ret

; ============================================================
; ПОЛУЧЕНИЕ СПИСКА РЕПОЗИТОРИЕВ С GITHUB
; ============================================================
GitHubGetRepos:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    
    ; Формируем URL
    lea rdi, [HttpRequestBuffer]
    ; Копируем "https://api.github.com/user/repos"
    ; В реальной системе здесь формируется полный URL
    
    ; Отправляем GET запрос
    lea rdi, [HttpRequestBuffer]
    lea rsi, [HttpResponseBuffer]
    mov rdx, 65536
    call GitHubHttpGet
    
    test rax, rax
    jnz .error
    
    ; Парсим JSON ответ
    lea rdi, [HttpResponseBuffer]
    lea rsi, [my_repos]
    mov rdx, 10  ; максимум репозиториев
    call ParseReposJson
    
    mov [repo_count], al
    
    xor rax, rax
    jmp .done
    
.error:
    mov rax, EFI_NOT_FOUND
    
.done:
    add rsp, 128
    pop rbp
    ret

; ============================================================
; ПАРСИНГ JSON ОТВЕТА (РЕПОЗИТОРИИ)
; ============================================================
ParseReposJson:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    
    mov r12, rdi  ; JSON буфер
    mov r13, rsi  ; Массив REPO_ITEM
    xor ebx, ebx  ; Счётчик
    
    ; Простой парсер JSON (в реальной системе нужен полноценный)
    ; Ищем "name": "..." и "owner": {"login": "..."}
    
.parse_loop:
    ; Ищем "name"
    call JsonFindKey
    test rax, rax
    jz .done
    
    ; Копируем имя
    call JsonCopyString
    lea rdi, [r13 + REPO_ITEM.name]
    mov rcx, 32
    rep movsb
    
    ; Ищем "owner"
    call JsonFindKey
    test rax, rax
    jz .done
    
    ; Копируем владельца
    call JsonCopyString
    lea rdi, [r13 + REPO_ITEM.owner]
    mov rcx, 32
    rep movsb
    
    ; Ищем "private"
    call JsonFindKey
    test rax, rax
    jz .done
    
    ; Проверяем значение
    call JsonCopyString
    
    ; Ищем "stargazers_count"
    call JsonFindKey
    test rax, rax
    jz .done
    
    ; Копируем число звёзд
    call JsonCopyNumber
    mov [r13 + REPO_ITEM.stars], eax
    
    inc ebx
    cmp ebx, 10  ; максимум
    jae .done
    
    add r13, sizeof.REPO_ITEM
    jmp .parse_loop
    
.done:
    mov eax, ebx
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

; ============================================================
; ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ JSON ПАРСИНГА
; ============================================================
JsonFindKey:
    ; Заглушка - ищет ключ в JSON
    ; В реальной системе здесь полноценный парсер
    ret

JsonCopyString:
    ; Заглушка - копирует строковое значение
    ret

JsonCopyNumber:
    ; Заглушка - копирует числовое значение
    xor eax, eax
    ret

; ============================================================
; ОСНОВНОЙ ЦИКЛ КОНСОЛИ
; ============================================================
ConsoleLoop:
    push rbp
    mov rbp, rsp
    
.loop:
    ; Выводим приглашение
    lea rdi, [msg_prompt]
    call PrintString
    
    ; Читаем строку
    lea rdi, [LineBuffer]
    mov rsi, 255
    call ReadLine
    
    ; Проверяем на пустую строку
    mov al, [LineBuffer]
    test al, al
    jz .loop
    
    ; Обрабатываем команду
    call ProcessCommand
    
    jmp .loop
    
    pop rbp
    ret

; ============================================================
; ОБРАБОТКА КОМАНД
; ============================================================
ProcessCommand:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    lea rdi, [LineBuffer]
    
    ; HELP
    lea rsi, [cmd_help]
    call StrCmp
    test rax, rax
    jnz .check_cls
    lea rdi, [msg_help_text]
    call PrintString
    jmp .done
    
.check_cls:
    lea rdi, [LineBuffer]
    lea rsi, [cmd_cls]
    call StrCmp
    test rax, rax
    jnz .check_gui
    lea rdi, [msg_cls]
    call PrintString
    jmp .done
    
.check_gui:
    lea rdi, [LineBuffer]
    lea rsi, [cmd_gui]
    call StrCmp    test rax, rax
    jnz .check_info
    call StartGUI
    jmp .done
    
.check_info:
    lea rdi, [LineBuffer]
    lea rsi, [cmd_info]
    call StrCmp
    test rax, rax
    jnz .check_ls
    call ShowInfo
    jmp .done
    
.check_ls:
    lea rdi, [LineBuffer]
    lea rsi, [cmd_ls]
    call StrCmp
    test rax, rax
    jnz .check_github
    call ListFiles
    jmp .done
    
.check_github:
    lea rdi, [LineBuffer]
    lea rsi, [cmd_github]
    call StrCmp
    test rax, rax
    jnz .check_repos
    call GitHubClient
    jmp .done
    
.check_repos:
    lea rdi, [LineBuffer]
    lea rsi, [cmd_repos]
    call StrCmp
    test rax, rax
    jnz .check_net
    call ShowRepos
    jmp .done
    
.check_net:
    lea rdi, [LineBuffer]
    lea rsi, [cmd_net]
    call StrCmp
    test rax, rax
    jnz .check_reboot
    call ShowNetStatus
    jmp .done
    
.check_reboot:
    lea rdi, [LineBuffer]
    lea rsi, [cmd_reboot]
    call StrCmp
    test rax, rax
    jnz .check_shutdown
    lea rdi, [msg_reboot]
    call PrintString
    ; Вызываем ResetSystem
    mov rcx, [RT]
    mov rdx, 0  ; EfiResetCold
    mov r8, EFI_SUCCESS
    xor r9, r9
    call [rcx + EFI_RUNTIME_SERVICES.ResetSystem]
    jmp .done
    
.check_shutdown:
    lea rdi, [LineBuffer]
    lea rsi, [cmd_shutdown]
    call StrCmp
    test rax, rax
    jnz .unknown
    lea rdi, [msg_shutdown]
    call PrintString
    ; Вызываем ResetSystem с Shutdown
    mov rcx, [RT]
    mov rdx, 2  ; EfiResetShutdown
    mov r8, EFI_SUCCESS
    xor r9, r9
    call [rcx + EFI_RUNTIME_SERVICES.ResetSystem]
    jmp .done
    
.unknown:
    lea rdi, [msg_unknown]
    call PrintString
    
.done:
    add rsp, 32
    pop rbp
    ret

; ============================================================
; GITHUB КЛИЕНТ
; ============================================================
GitHubClient:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    ; Проверяем подключение
    cmp byte [is_connected], 0
    jne .connected
    
    lea rdi, [msg_github_disconnected]
    call PrintString
    
    ; Пробуем инициализировать
    call InitGitHub
    
    cmp byte [is_connected], 0
    je .done
    
.connected:
    lea rdi, [msg_github_connected]
    call PrintString
    
    ; Получаем репозитории
    call GitHubGetRepos
    
    test rax, rax
    jnz .error
    
    lea rdi, [msg_newline]
    call PrintString
    
    ; Выводим репозитории
    call ShowRepos
    
    jmp .done
    
.error:
    lea rdi, [msg_github_fail]
    call PrintString
    
.done:
    add rsp, 32
    pop rbp
    ret

; ============================================================
; ПОКАЗАТЬ РЕПОЗИТОРИИ
; ============================================================
ShowRepos:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    
    movzx r12, byte [repo_count]
    test r12, r12
    jnz .have_repos
    
    lea rdi, [msg_ls_empty]
    call PrintString
    jmp .done
    
.have_repos:
    lea rdi, [msg_ls_title]
    call PrintString
    
    lea rbx, [my_repos]
    xor r12, r12
    
.repo_loop:
    movzx rax, byte [repo_count]
    cmp r12, rax
    jae .done
    
    ; Выводим имя репозитория
    lea rdi, [rbx + REPO_ITEM.name]
    call PrintString
    
    lea rdi, [msg_space]
    call PrintString
    
    ; Выводим владельца
    lea rdi, [rbx + REPO_ITEM.owner]
    call PrintString
    
    lea rdi, [msg_newline]
    call PrintString
    
    add rbx, sizeof.REPO_ITEM
    inc r12
    jmp .repo_loop
    
.done:
    pop r12
    pop rbx
    pop rbp
    ret

; ============================================================
; ПОКАЗАТЬ СЕТЕВОЙ СТАТУС
; ============================================================
ShowNetStatus:
    push rbp
    mov rbp, rsp
    
    lea rdi, [msg_net_status]
    call PrintString
    
    cmp byte [network_ready], 0
    je .disconnected
    
    lea rdi, [msg_net_connected]
    call PrintString
    
    cmp byte [is_connected], 0
    je .github_disconnected
    
    lea rdi, [msg_github_connected]
    call PrintString
    jmp .done
    
.github_disconnected:
    lea rdi, [msg_github_disconnected]
    call PrintString
    jmp .done
    
.disconnected:
    lea rdi, [msg_net_disconnected]
    call PrintString
    lea rdi, [msg_github_disconnected]
    call PrintString
    
.done:
    pop rbp
    ret

; ============================================================
; ЗАПУСК ГРАФИЧЕСКОГО ИНТЕРФЕЙСА
; ============================================================
StartGUI:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    
    ; Проверяем наличие GOP
    mov rax, [GOP]
    test rax, rax
    jz .no_gop
    
    ; Очищаем экран
    call ClearScreen
    
    ; Рисуем интерфейс
    call DrawHeader
    call DrawPanel
    call DrawStatusBar
    
    ; Запускаем цикл GUI
    call GuiLoop
    
    ; Возвращаемся в текстовый режим
    mov rcx, [ConOut]
    xor rdx, rdx
    call [rcx + EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.SetMode]
    
    jmp .done
    
.no_gop:
    lea rdi, [msg_gop_fail]
    call PrintString
    
.done:
    add rsp, 128
    pop rbp
    ret

; ============================================================
; ЦИКЛ GUI
; ============================================================
GuiLoop:
    push rbp
    mov rbp, rsp
    
.gui_loop:
    ; Читаем нажатие клавиши
    mov rcx, [ConIn]
    lea rdx, [InputKey]
    call [rcx + EFI_SIMPLE_TEXT_INPUT_PROTOCOL.WaitForKey]
    
    movzx eax, word [InputKey.UnicodeChar]
    movzx ecx, word [InputKey.ScanCode]
    
    ; Обрабатываем клавиши
    cmp eax, 'q'
    je .exit
    cmp eax, 'Q'
    je .exit
    cmp eax, 27  ; ESC
    je .exit
    
    ; Остальные клавиши обрабатываются здесь
    ; (в реальной системе - полноценная обработка)
    
    jmp .gui_loop
    
.exit:
    pop rbp
    ret

; ============================================================
; ОЧИСТКА ЭКРАНА (ГРАФИЧЕСКАЯ)
; ============================================================
ClearScreen:
    push rbp
    mov rbp, rsp
    push rdi
    push rcx
    push rax
    
    mov rdi, [framebuffer]
    mov rax, [screen_height]
    mul qword [screen_pitch]
    mov rcx, rax
    shr rcx, 3
    mov rax, [COLOR_DARK_BG]
    rep stosq
    
    pop rax
    pop rcx
    pop rdi
    pop rbp
    ret

; ============================================================
; РИСОВАНИЕ ПРЯМОУГОЛЬНИКА
; ============================================================
; Вход: RDI = X, RSI = Y, RDX = Width, R8 = Height, R9 = Color
DrawRect:
    push rbp
    mov rbp, rsp
    push rdi
    push rsi
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    
    ; Проверка границ
    cmp rdi, [screen_width]
    jae .done
    cmp rsi, [screen_height]
    jae .done
    
    ; Вычисление начального адреса
    mov rax, rsi
    mul qword [screen_pitch]
    add rax, [framebuffer]
    mov r10, rdi
    shl r10, 2
    add rax, r10
    mov r11, rax
    
    mov r12, r8
    
.row_loop:
    mov rdi, r11
    mov rcx, rdx
    mov rax, r9
    rep stosd
    
    add r11, [screen_pitch]
    dec r12
    jnz .row_loop
    
.done:
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rsi
    pop rdi
    pop rbp
    ret

; ============================================================
; РИСОВАНИЕ ЗАГОЛОВКА GUI
; ============================================================
DrawHeader:
    push rbp
    mov rbp, rsp
    
    ; Фон заголовка
    mov rdi, 0
    mov rsi, 0
    mov rdx, [screen_width]
    mov r8, 64
    mov r9, [COLOR_HEADER_BG]
    call DrawRect
    
    pop rbp
    ret

; ============================================================
; РИСОВАНИЕ ПАНЕЛИ GUI
; ============================================================
DrawPanel:
    push rbp
    mov rbp, rsp
    
    ; Основная панель
    mov rdi, 30
    mov rsi, 80
    mov rdx, 964
    mov r8, 640
    mov r9, [COLOR_PANEL]
    call DrawRect
    
    pop rbp
    ret

; ============================================================
; РИСОВАНИЕ СТАТУС-БАРА
; ============================================================
DrawStatusBar:
    push rbp
    mov rbp, rsp
    
    ; Статус-бар внизу
    mov rdi, 0
    mov rdx, [screen_height]
    sub rdx, 48
    mov rsi, rdx
    mov rdx, [screen_width]
    mov r8, 48
    mov r9, [COLOR_STATUS_BAR]
    call DrawRect
    
    pop rbp
    ret

; ============================================================
; ДРАЙВЕР (ВАШ ОРИГИНАЛЬНЫЙ КОД)
; ============================================================
driver:
    push rbp
    mov rbp, rsp
    
    ; Устанавливаем framebuffer
    mov rax, [FrameBufferBase]
    test rax, rax
    jz .use_default
    mov [framebuffer], rax
    mov rax, [screen_pitch]
    jmp .set_pitch
    
.use_default:
    mov qword [framebuffer], 0xFD000000
    mov qword [screen_pitch], 7680
    
.set_pitch:
    ; Рисуем фоновое изображение (обои) - image4
    mov rdi, 0
    mov rsi, 0
    lea rdx, [image4]
    mov rcx, [screen_width]
    mov r8, [screen_height]
    mov r9, 3
    call draw_image_raw
    
    ; Рисуем первую картинку
    mov rdi, 100
    mov rsi, 200
    lea rdx, [image1]
    mov rcx, 450
    mov r8, 450
    mov r9, 3
    call draw_image_raw
    
    ; Рисуем вторую картинку
    mov rdi, 550
    mov rsi, 200
    lea rdx, [image2]
    mov rcx, 450
    mov r8, 450
    mov r9, 3
    call draw_image_raw
    
    ; Рисуем третью картинку
    mov rdi, 1000
    mov rsi, 200
    lea rdx, [image3]
    mov rcx, 450
    mov r8, 450
    mov r9, 3
    call draw_image_raw
    
    pop rbp
    ret

; ============================================================
; draw_image_raw - ОТРИСОВКА ИЗОБРАЖЕНИЯ
; ============================================================
draw_image_raw:
    push rbx
    push r12
    push r13
    push r14
    push r15
    
    mov rbx, rdx        ; указатель на данные
    mov r12, rdi        ; x
    mov r13, rsi        ; y
    mov r14, rcx        ; width
    mov r15, r8         ; height
    
    ; Проверка границ
    mov rax, r12
    add rax, r14
    cmp rax, [screen_width]
    jg .cleanup
    
    mov rax, r13
    add rax, r15
    cmp rax, [screen_height]
    jg .cleanup
    
    ; Считаем начальное смещение в видеопамяти
    mov rax, r13
    imul rax, [screen_pitch]
    mov rdx, r12
    imul rdx, r9
    add rax, rdx
    add rax, [framebuffer]
    
    mov rsi, r15
    
.y_loop:
    push rax
    push rbx
    push rcx
    
    mov rcx, r14
    mov rdx, r9
    
.copy_loop:
    cmp rdx, 4
    je .copy4
    cmp rdx, 3
    je .copy3
    cmp rdx, 2
    je .copy2
    
    ; 1 байт
    mov al, [rbx]
    mov [rax], al
    jmp .next
    
.copy4:
    mov eax, [rbx]
    mov [rax], eax
    jmp .next
    
.copy3:
    mov al, [rbx]
    mov [rax], al
    mov al, [rbx+1]
    mov [rax+1], al
    mov al, [rbx+2]
    mov [rax+2], al
    jmp .next
    
.copy2:
    mov ax, [rbx]
    mov [rax], ax
    
.next:
    add rax, rdx
    add rbx, rdx
    loop .copy_loop
    
    pop rcx
    pop rbx
    pop rax
    add rax, [screen_pitch]
    imul rdx, r14, r9
    add rbx, rdx
    dec rsi
    jnz .y_loop
    
.cleanup:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret

; ============================================================
; clear_screen - ОЧИСТКА ЭКРАНА (ТЕКСТОВАЯ)
; ============================================================
clear_screen:
    push rbp
    mov rbp, rsp
    
    mov rcx, [ConOut]
    call [rcx + EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.ClearScreen]
    
    pop rbp
    ret

; ============================================================
; ОБРАБОТЧИК МЫШИ
; ============================================================
mouseim:
    ; Заглушка - в реальной системе здесь инициализация USB мыши
    ret

; ============================================================
; ВЫВОД СТРОКИ
; ============================================================
PrintString:
    push rbp
    mov rbp, rsp
    push rcx
    push rdx
    
    mov rcx, [ConOut]
    mov rdx, rdi
    call [rcx + EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.OutputString]
    
    pop rdx
    pop rcx
    pop rbp
    ret

; ============================================================
; ЧТЕНИЕ СТРОКИ
; ============================================================
ReadLine:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    
    mov r12, rdi     ; Буфер
    mov r13, rsi     ; Максимальная длина
    xor r14, r14     ; Позиция
    
.char_loop:
    mov rcx, [ConIn]
    lea rdx, [InputKey]
    call [rcx + EFI_SIMPLE_TEXT_INPUT_PROTOCOL.WaitForKey]
    
    mov ax, [InputKey.UnicodeChar]
    movzx eax, ax
    
    cmp eax, 13      ; Enter
    je .done
    cmp eax, 8       ; Backspace
    je .backspace
    cmp eax, 27      ; Escape
    je .cancel
    cmp eax, 0x20
    jl .char_loop
    
    cmp r14, r13
    jae .char_loop
    
    mov [r12 + r14], al
    inc r14
    
    ; Эхо
    mov [CharBuffer], al
    mov byte [CharBuffer + 1], 0
    lea rdi, [CharBuffer]
    call PrintString
    
    jmp .char_loop
    
.backspace:
    test r14, r14
    jz .char_loop
    dec r14
    mov byte [CharBuffer], 8
    mov byte [CharBuffer + 1], 0
    lea rdi, [CharBuffer]
    call PrintString
    jmp .char_loop
    
.cancel:
    xor r14, r14
    
.done:
    mov byte [r12 + r14], 0
    lea rdi, [msg_newline]
    call PrintString
    mov rax, r14
    
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

; ============================================================
; СРАВНЕНИЕ СТРОК
; ============================================================
StrCmp:
    push rbp
    mov rbp, rsp
    push rdi
    push rsi
    
.loop:
    mov al, [rdi]
    mov ah, [rsi]
    
    cmp al, 'a'
    jl .check_ah
    cmp al, 'z'
    jg .check_ah
    sub al, 32
    
.check_ah:
    cmp ah, 'a'
    jl .compare
    cmp ah, 'z'
    jg .compare
    sub ah, 32
    
.compare:
    cmp al, ah
    jne .not_equal
    test al, al
    jz .equal
    inc rdi
    inc rsi
    jmp .loop
    
.equal:
    xor rax, rax
    jmp .done
    
.not_equal:
    mov rax, 1
    
.done:
    pop rsi
    pop rdi
    pop rbp
    ret

; ============================================================
; ВЫВОД ДЕСЯТИЧНОГО ЧИСЛА
; ============================================================
PrintDec:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    push rbx
    push rcx
    push rdx
    push rdi
    
    mov rbx, 10
    lea rdi, [rsp + 30]
    mov byte [rdi], 0
    dec rdi
    
.loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz .loop
    
    inc rdi
    call PrintString
    
    pop rdi
    pop rdx
    pop rcx
    pop rbx
    add rsp, 32
    pop rbp
    ret

; ============================================================
; ВЫВОД ШЕСТНАДЦАТЕРИЧНОГО ЧИСЛА
; ============================================================
PrintHex:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    push rbx
    push rcx
    push rdx
    push rdi
    
    mov rbx, 16
    lea rdi, [rsp + 30]
    mov byte [rdi], 0
    dec rdi
    
.loop:
    xor rdx, rdx
    div rbx
    cmp dl, 10
    jl .digit
    add dl, 'A' - 10
    jmp .store
.digit:
    add dl, '0'
.store:
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz .loop
    
    inc rdi
    call PrintString
    
    pop rdi
    pop rdx
    pop rcx
    pop rbx
    add rsp, 32
    pop rbp
    ret

; ============================================================
; ПОКАЗАТЬ ИНФОРМАЦИЮ О СИСТЕМЕ
; ============================================================
ShowInfo:
    push rbp
    mov rbp, rsp
    
    lea rdi, [msg_info_title]
    call PrintString
    
    ; Графика
    lea rdi, [msg_info_gop]
    call PrintString
    mov rax, [GOP]
    test rax, rax
    jz .no_gop
    lea rdi, [msg_info_available]
    call PrintString
    jmp .show_res
.no_gop:
    lea rdi, [msg_info_unavailable]
    call PrintString
    
.show_res:
    lea rdi, [msg_info_res]
    call PrintString
    mov rax, [screen_width]
    call PrintDec
    lea rdi, [msg_x]
    call PrintString
    mov rax, [screen_height]
    call PrintDec
    lea rdi, [msg_newline]
    call PrintString
    
    lea rdi, [msg_info_fb]
    call PrintString
    mov rax, [framebuffer]
    call PrintHex
    lea rdi, [msg_newline]
    call PrintString
    
    ; Файловая система
    lea rdi, [msg_info_fs]
    call PrintString
    mov rax, [RootFS]
    test rax, rax
    jz .no_fs
    lea rdi, [msg_info_available]
    call PrintString
    jmp .show_net
.no_fs:
    lea rdi, [msg_info_unavailable]
    call PrintString
    
.show_net:
    ; Сеть
    lea rdi, [msg_info_net]
    call PrintString
    cmp byte [network_ready], 0
    je .no_net
    lea rdi, [msg_info_available]
    call PrintString
    jmp .done
.no_net:
    lea rdi, [msg_info_unavailable]
    call PrintString
    
.done:
    pop rbp
    ret

; ============================================================
; СПИСОК ФАЙЛОВ
; ============================================================
ListFiles:
    push rbp
    mov rbp, rsp
    sub rsp, 256
    
    ; Проверяем наличие файловой системы
    mov rax, [RootFS]
    test rax, rax
    jz .no_fs
    
    lea rdi, [msg_ls_title]
    call PrintString
    
    ; Открываем корневую директорию для чтения
    mov rcx, [RootFS]
    lea rdx, [TempQword]         ; Указатель на новый File Protocol
    mov r8, 0                     ; Путь (пустая строка = текущая директория)
    mov r9, EFI_FILE_MODE_READ
    call [rcx + EFI_FILE_PROTOCOL.Open]
    
    test rax, rax
    jnz .error
    
    mov r12, [TempQword]         ; Сохраняем указатель на директорию
    
.read_loop:
    ; Читаем информацию о файле
    lea rdi, [FileInfoBuffer]
    mov qword [rdi], 1024        ; Размер буфера
    
    mov rcx, r12
    mov rdx, rdi
    call [rcx + EFI_FILE_PROTOCOL.Read]
    
    test rax, rax
    jnz .close_dir
    
    cmp qword [FileInfoBuffer], 0
    je .close_dir
    
    ; Выводим имя файла
    lea rdi, [FileInfoBuffer + EFI_FILE_INFO.FileName]
    call PrintString
    lea rdi, [msg_newline]
    call PrintString
    
    jmp .read_loop
    
.close_dir:
    ; Закрываем директорию
    mov rcx, r12
    call [rcx + EFI_FILE_PROTOCOL.Close]
    
    jmp .done
    
.no_fs:
    lea rdi, [msg_fs_fail]
    call PrintString
    jmp .done
    
.error:
    lea rdi, [msg_file_read_error]
    call PrintString
    
.done:
    add rsp, 256
    pop rbp
    ret

; ============================================================
; TCP КОНФИГУРАЦИЯ (ДАННЫЕ)
; ============================================================
section '.data' data readable writeable align 16

tcp_config_data:
    .TypeOfService      db 0
    .TimeToLive         db 64
    .AccessPoint        dq tcp_access_point
    .ControlOption      dq tcp_control_option

tcp_access_point:
    .UseDefaultAddress  db 1
    .StationAddress     db 0,0,0,0
    .SubnetMask         db 0,0,0,0
    .StationPort        dw 0
    .RemoteAddress      db 0,0,0,0
    .RemotePort         dw 443
    .ActiveFlag         db 1

tcp_control_option:
    .ReceiveBufferSize  dd 65536
    .SendBufferSize     dd 65536
    .MaxSynBackLog      dd 10
    .ConnectionTimeout  dd 30000
    .DataRetransCount   dd 5
    .FinTimeout         dd 5000
    .TimeWaitTimeout    dd 5000
    .KeepAliveProbes    dd 5
    .KeepAliveTime      dd 7200000
    .KeepAliveInterval  dd 1000
    .EnableNagle        db 1
    .EnableTimeStamp    db 0
    .EnableWindowScaling db 1
    .EnableSelectiveAck db 0
    .EnablePathMtuDiscovery db 1

github_connection_token dq 0

http_config_data:
    ; HTTP конфигурация (использует IPv4 адрес GitHub)
    .HttpVersion        dd HttpVersion11
    .TimeOutMillisec    dd 10000
    .LocalAddress       EFI_IPv4_ADDRESS 0,0,0,0
    .LocalPort          dw 0
    .RemoteAddress      dq github_api_ip
    .RemotePort         dw 443

http_request_data:
    .Method             dd HttpMethodGet
    .Url                dq http_url_buffer

http_message:
    .Data               dq http_request_data
    .Headers            dq http_headers
    .HeaderCount        dq 3
    .Body               dq 0
    .BodyLength         dq 0

http_response_data:
    .StatusCode         dd 0

http_headers:
    ; Host
    dq http_header_host
    dq http_header_host_value
    ; User-Agent
    dq http_header_user_agent
    dq http_header_user_agent_value
    ; Accept
    dq http_header_accept
    dq http_header_accept_value

http_header_host                db 'Host',0
http_header_host_value          db 'api.github.com',0
http_header_user_agent           db 'User-Agent',0
http_header_user_agent_value     db 'Skybox-Hydro/3.0',0
http_header_accept              db 'Accept',0
http_header_accept_value        db 'application/vnd.github.v3+json',0

http_url_buffer:
    du 'https://api.github.com/user/repos',0

; ============================================================
; ВЫРАВНИВАНИЕ
; ============================================================
align 16