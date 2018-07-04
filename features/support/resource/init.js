use unoms;

//Initialize system settings
var API_PREFIX = '/api/v1';
var settings = {
    auto_mount: false,
    smtp_host: "smtp.mxhichina.com",
    smtp_port: 465,
    smtp_username: "john.doe@unosys.io",
    smtp_password: "john@uno2017",
    smtp_from: "john.doe@unosys.io",
    smtp_tls: true,
    pbx_username: "asterisk",
    pbx_password: "123456",
    crm_type: "SuiteCRM",
    crm_url: "",
    crm_username: "",
    crm_password: ""
};

var oldSettings = db.settings.findOne();
if (oldSettings) {
    for (var k in settings) {
        if (!oldSettings.hasOwnProperty(k)) {
            oldSettings[k] = settings[k];
        }
    }
    db.settings.update({}, {$set: oldSettings});
} else {
    db.settings.insert(settings);
}


var grid_states = [
    {
        name: 'device',
        fields: ['name', 'serial_number', 'oui', 'product_class', 'manufacturer', 'online', 'last_online_time', 'firmware_version']
    },
    {
        name: 'alarm',
        fields: ['device_name', 'cleared', 'perceived_severity', 'raised_time', 'cleared_time', 'identifier', 'event_type', 'probable_cause', 'specific_problem']
    },
    {
        name: 'firmware', fields: ['version_number', 'oui', 'product_class', 'suitable_versions', 'url']
    },
    {
        name: 'software', fields: ['name', 'vendor', 'version_number', 'suitable_versions', 'url', 'uuid']
    },
    {
        name: 'action', fields: ['name', 'device_name', 'status', 'create_time', 'complete_time', 'result', 'arguments']
    }
];
db.grid_state.remove({});
for (var i = 0; i < grid_states.length; i++) {
    db.grid_state.insert(grid_states[i]);
}


//Initialize permission
db.permission.createIndex({name: 1, operations: 1}, {unique: true});

var permissions = [
    {
        name: "Device",
        operations: ["create", "read", "update", "delete"],
        dependencies: ["Subscriber", "Domain", "Tag"],
        desc: "Management device repository"
    },
    {
        name: "Subscriber",
        operations: ["create", "read", "update", "delete"],
        dependencies: ["Domain", "Tag"],
        desc: "Management subscriber repository"
    },
    {
        name: "Subscription",
        operations: ["read"],
        dependencies: ["Device", "Domain"],
        desc: "Management subscription"
    },
    {
        name: "Order",
        operations: ["create", "read"],
        dependencies: ["Domain", "Tag", "Service", "Subscriber"],
        desc: "Management order"
    },
    {
        name: "Backup",
        operations: ["read", "delete"],
        dependencies: ["Domain"],
        desc: "Device backup files"
    },
    {
        name: "DeviceLog",
        operations: ["read", "delete"],
        dependencies: ["Domain"],
        desc: "Device log files"
    },
    {
        name: "Tag",
        operations: ["create", "read", "update", "delete"],
        dependencies: [],
        desc: "Management tag"
    },
    {
        name: "Firmware",
        operations: ["create", "read", "update", "delete"],
        dependencies: [],
        desc: "Operate firmware ineventory"
    },
    {
        name: "Script",
        operations: ["create", "read", "update", "delete"],
        dependencies: [],
        desc: "Management blockly/lua script"
    },
    {
        name: "Event",
        operations: ["create", "read", "update", "delete"],
        dependencies: ["Tag", "Script"],
        desc: "Management event"
    },
    {
        name: "Service",
        operations: ["create", "read", "update", "delete"],
        dependencies: ["Script"],
        desc: "Management service"
    },
    {
        name: "Scheduler",
        operations: ["create", "read", "update", "delete"],
        dependencies: ["Script", "Tag"],
        desc: "Management scheduler"
    },
    {
        name: "Action",
        operations: ["create", "read", "update", "delete"],
        dependencies: ["Device", "Domain", "Tag", "Service", "Backup", "DeviceLog", "Firmware", "Script", "Software"],
        desc: "Operate device"
    },
    {
        name: "Domain",
        operations: ["create", "read", "update", "delete"],
        dependencies: [],
        desc: "Admin domain"
    },
    {
        name: "Dashboard",
        operations: ["read"],
        dependencies: [],
        desc: "Dash board"
    },
    {
        name: "Software",
        operations: ["create", "read", "update", "delete"],
        dependencies: [],
        desc: "Software management"
    },
    {
        name: "Alarm",
        operations: ["read", "update", "delete"],
        dependencies: ["domain", "device"],
        desc: "Alarm/Fault management"
    },
    {
        name: "Thing",
        operations: ["create", "read", "update", "delete"],
        dependencies: ["domain", "device", "tag"],
        desc: "Sensor/Actuator management"
    },
    {
        name: "NetworkFailure",
        operations: ["create", "read", "update", "delete"],
        dependencies: ["domain"],
        desc: "Network failure management"
    }
];


for (var i = 0; i < permissions.length; i++) {
    var p = permissions[i]
    db.permission.update({name: p.name}, {
        $setOnInsert: p
    }, {upsert: true})
}

//Initialize gridfs
db.fs.files.createIndex({filename: 1}, {unique: true})

//Initialize tag
db.tag.createIndex({name: 1}, {unique: true})

//Initialize role
db.role.createIndex({name: 1}, {unique: true})

//Initialize domain
db.domain.createIndex({path: 1}, {unique: true})

//Initialize log
db.log.createIndex({create_time: 1}, {expireAfterSeconds: 3600 * 24 * 100})
db.log.createIndex({username: 1})
db.log.createIndex({ip: 1})
db.log.createIndex({result: 1})


//Initialize user
db.user.createIndex({username: 1}, {unique: true})
db.user.createIndex({email: 1}, {unique: true})
db.user.createIndex({domain: 1})
db.user.createIndex({oui: 1})
db.user.createIndex({tags: 1})
db.user.update({username: "root"}, {
    $inc: {
        version: 1
    },
    $set: {
        modify_time: new ISODate(),
        retry_count: 0,
        locked: false
    },
    $setOnInsert: {
        create_time: new ISODate(),

        //Modification point
        username: "root",
        password: "78bf5d3d3177e92067a09149da0a114c3e6e442c", //123456
        salt: "UGEAHSPVQPJXHLKQYXDHEANVFFLTNSRV",
        email: "john.doe@unosys.io",
        administrator: true
    }
}, {upsert: true})

//Initialize ftp user
db.ftp_user.createIndex({username: 1}, {unique: true})


//Initialize device
db.device.createIndex({name: 1}, {unique: true})
db.device.createIndex({serial_number: 1, oui: 1, product_class: 1}, {unique: true})
db.device.createIndex({identity: 1}, {unique: true, sparse: true})
db.device.createIndex({model: 1})
db.device.createIndex({mac_address: 1})
db.device.createIndex({last_online_time: 1})
db.device.createIndex({subscriber_id: 1, subscriber_name: 1})
db.device.createIndex({domain: 1})
db.device.createIndex({tags: 1})
db.device.createIndex({firmware_version: 1})
db.device.createIndex({manufacturer: 1})
db.device.createIndex({create_time: 1})
db.device.createIndex({protocol: 1, ip_address: 1})
db.device.createIndex({coordinate: "2dsphere"})

//Initialize action
db.action.createIndex({name: 1})
db.action.createIndex({status: 1})
db.action.createIndex({create_time: 1})
db.action.createIndex({device_name: 1})
db.action.createIndex({domain: 1})
db.action.createIndex({tags: 1})
db.action.createIndex({application: 1}, {sparse: true})

//Initialize script
db.script.createIndex({name: 1, protocol: 1}, {unique: true})
db.script.createIndex({built_in: 1})

function addBuiltInScript(name, options) {
    options = options || {};
    options.schema = options.schema || [];
    options.category = options.category || 'Action';
    options.protocol = options.protocol || 'CWMP';
    options.group = options.group == undefined ? 'Action' : options.group;
    options.icon = options.icon || "";
    options.icon_type = options.icon_type || "font/iconfont";

    db.script.update({name: name, protocol: options.protocol}, {
        $inc: {
            version: 1
        },
        $set: {
            modify_time: new ISODate(),
            built_in: true,
            schema: JSON.stringify(options.schema),
            category: options.category,
            protocol: options.protocol,
            group: options.group,
            icon: options.icon,
            icon_type: options.icon_type,
        },
        $setOnInsert: {
            create_time: new ISODate(),
        }
    }, {upsert: true})
}


var ntpServers = [
    "time.windows.com",
    "time.nist.gov",
    "time.apple.com",
    "0.pool.ntp.org",
    "1.pool.ntp.org",
    "2.pool.ntp.org"]

// Generated by posix_tz.rb
var timeZones = [
    "Africa/Cairo(EET-2)",
    "Africa/Casablanca(WET0)",
    "Africa/Johannesburg(SAST-2)",
    "Africa/Lagos(WAT-1)",
    "Africa/Nairobi(EAT-3)",
    "Africa/Windhoek(WAT-1WAST,M9.1.0,M4.1.0)",
    "America/Anchorage(AKST9AKDT,M3.2.0,M11.1.0)",
    "America/Asuncion(PYT4PYST,M10.3.0/0,M3.2.0/0)",
    "America/Bahia(BRT3)",
    "America/Bogota(COT5)",
    "America/Caracas(VET4:30)",
    "America/Cayenne(GFT3)",
    "America/Chicago(CST6CDT,M3.2.0,M11.1.0)",
    "America/Chihuahua(MST7MDT,M4.1.0,M10.5.0)",
    "America/Cuiaba(AMT4AMST,M10.2.0/0,M2.3.0/0)",
    "America/Denver(MST7MDT,M3.2.0,M11.1.0)",
    "America/Godthab(WGT3WGST,M3.2.0,M11.1.0)",
    "America/Guatemala(CST6)",
    "America/Halifax(AST4ADT,M3.2.0,M11.1.0)",
    "America/La_Paz(BOT4)",
    "America/Los_Angeles(PST8PDT,M3.2.0,M11.1.0)",
    "America/Mexico_City(CST6CDT,M4.1.0,M10.5.0)",
    "America/Montevideo(UYT3UYST,M10.1.0,M3.2.0)",
    "America/New_York(EST5EDT,M3.2.0,M11.1.0)",
    "America/Phoenix(MST7)",
    "America/Santa_Isabel(PST8PDT,M4.1.0,M10.5.0)",
    "America/Santiago(CLT+4CLST,M10.2.0,M3.2.0)",
    "America/Sao_Paulo(BRT3BRST,M10.2.0/0,M2.3.0/0)",
    "America/St_Johns(NST3:30NDT,M3.2.0/0:01,M11.1.0/0:01)",
    "America/Winnipeg(CST6CDT,M3.2.0,M11.1.0)",
    "Asia/Almaty(ALMT-6)",
    "Asia/Amman(EET-2EEST,M3.5.4/0,M10.5.5/1)",
    "Asia/Baghdad(AST-3)",
    "Asia/Baku(AZT-4AZST,M3.5.0/4,M10.5.0/5)",
    "Asia/Bangkok(ICT-7)",
    "Asia/Beirut(EET-2EEST,M3.5.0/0,M10.5.0/0)",
    "Asia/Calcutta(IST-5:30)",
    "Asia/Colombo(IST-5:30)",
    "Asia/Damascus(EET-2EEST,M4.1.5/0,M10.5.5/0)",
    "Asia/Dhaka(BDT-6)",
    "Asia/Dubai(GST-4)",
    "Asia/Irkutsk(IRKT-9)",
    "Asia/Jerusalem(IST-2IDT,M3.5.5,M9.4.0)",
    "Asia/Kabul(AFT-4:30)",
    "Asia/Kamchatka(PETT-12)",
    "Asia/Karachi(PKT-5)",
    "Asia/Kathmandu(NPT-5:45)",
    "Asia/Krasnoyarsk(KRAT-8)",
    "Asia/Magadan(MAGT-12)",
    "Asia/Nicosia(EET-2EEST,M3.5.0/3,M10.5.0/4)",
    "Asia/Novosibirsk(NOVT-7)",
    "Asia/Rangoon(MMT-6:30)",
    "Asia/Riyadh(AST-3)",
    "Asia/Seoul(KST-9)",
    "Asia/Shanghai(CST-8)",
    "Asia/Singapore(SGT-8)",
    "Asia/Taipei(CST-8)",
    "Asia/Tashkent(UZT-5)",
    "Asia/Tbilisi(GET-4)",
    "Asia/Tehran(IRDT)",
    "Asia/Tokyo(JST-9)",
    "Asia/Ulaanbaatar(ULAT-8)",
    "Asia/Vladivostok(VLAT-11)",
    "Asia/Yakutsk(YAKT-10)",
    "Asia/Yekaterinburg(YEKT-6)",
    "Asia/Yerevan(AMT-4AMST,M3.5.0,M10.5.0/3)",
    "Atlantic/Azores(AZOT1AZOST,M3.5.0/0,M10.5.0/1)",
    "Atlantic/Cape_Verde(CVT1)",
    "Atlantic/Reykjavik(GMT0)",
    "Australia/Adelaide(CST-9:30CST,M10.1.0,M4.1.0/3)",
    "Australia/Brisbane(EST-10)",
    "Australia/Darwin(CST-9:30)",
    "Australia/Hobart(EST-10EST,M10.1.0,M4.1.0/3)",
    "Australia/Perth(WST-8)",
    "Australia/Sydney(EST-10EST,M10.1.0,M4.1.0/3)",
    "Etc/GMT(GMT0)",
    "Etc/GMT+11(GMT11)",
    "Etc/GMT+12(GMT12)",
    "Etc/GMT+2(GMT2)",
    "Etc/GMT-12(GMT-12)",
    "Europe/Berlin(CET-1CEST,M3.5.0,M10.5.0/3)",
    "Europe/Bucharest(EET-2EEST,M3.5.0/3,M10.5.0/4)",
    "Europe/Budapest(CET-1CEST,M3.5.0,M10.5.0/3)",
    "Europe/Istanbul(EET-2EEST,M3.5.0/3,M10.5.0/4)",
    "Europe/Kaliningrad(EET-2EEST,M3.5.0,M10.5.0/3)",
    "Europe/Kiev(EET-2EEST,M3.5.0/3,M10.5.0/4)",
    "Europe/London(GMT0BST,M3.5.0/1,M10.5.0)",
    "Europe/Moscow(MSK-4)",
    "Europe/Paris(CET-1CEST,M3.5.0,M10.5.0/3)",
    "Europe/Warsaw(CET-1CEST,M3.5.0,M10.5.0/3)",
    "Indian/Mauritius(MUT-4)",
    "Pacific/Apia(WST13)",
    "Pacific/Auckland(NZST-12NZDT,M9.5.0,M4.1.0/3)",
    "Pacific/Fiji(FJT-12)",
    "Pacific/Guadalcanal(SBT-11)",
    "Pacific/Honolulu(HST10)",
    "Pacific/Port_Moresby(PGT-10)",
    "Pacific/Tongatapu(TOT-13)"
]

addBuiltInScript("Time", {
    schema: [
        {
            name: 'Enable',
            type: 'bool'
        },
        {
            name: 'NTPServer1',
            type: 'combo',
            options: {
                items: ntpServers
            }
        },
        {
            name: 'NTPServer2',
            type: 'combo',
	    options: {
		items: ntpServers
	    }
        },
        {
            name: 'NTPServer3',
            type: 'combo',
	    options: {
		items: ntpServers
	    }
        },
        {
            name: 'NTPServer4',
            type: 'combo',
	    options: {
		items: ntpServers
	    }
        },
        {
            name: 'NTPServer5',
            type: 'combo',
	    options: {
		items: ntpServers
	    }
        },
	{
	    name: 'CurrentLocalTime',
	    type: 'dateTime'
	},
	{
	    name: 'LocalTimeZone',
	    type: 'string',
	},
	{
	    name: 'LocalTimeZoneName',
	    type: 'combo',
	    options: {
		items: timeZones
	    }
	},
	{
	    name: 'DaylightSavingsUsed',
	    type: 'bool'
	},
	{
	    name: 'DaylightSavingsStart',
	    type: 'dateTime'
	},
	{
	    name: 'DaylightSavingsEnd',
	    type: 'dateTime'
	}	
    ], category: 'Action', group: 'Action', icon: 'time'
});

addBuiltInScript("Sync Software", {category: 'Action', group: 'Action', icon: 'sync-software'});
addBuiltInScript("Inspect Service", {
    schema: [
        {
            name: 'Service',
            type: 'list',
            required: true,
            options: {
                url: API_PREFIX + '/subscription/read?subscriber_id=${SUBSCRIBER_ID}',
                recText: 'service_name',
            },
        },
    ], group: 'Diagnostics', icon: 'inspect'
});
addBuiltInScript("Enable Service", {
    schema: [
        {
            name: 'Service',
            type: 'list',
            required: true,
            options: {
                url: API_PREFIX + '/subscription/read?subscriber_id=${SUBSCRIBER_ID}&enable=true',
                recText: 'service_name',
            },
        },
    ], group: 'Diagnostics', icon: 'enable'
});
addBuiltInScript("Disable Service", {
    schema: [
        {
            name: 'Service',
            type: 'list',
            required: true,
            options: {
                url: API_PREFIX + '/subscription/read?subscriber_id=${SUBSCRIBER_ID}&enable=false',
                recText: 'service_name',
            },
        },
    ], group: 'Diagnostics', icon: 'disable'
});
addBuiltInScript("IP Ping", {
    schema: [
        {
            name: 'Interface',
            type: 'combo',
            options: {
                items: [
                    "",
                    "Device.IP.Interface.1",
                    "Device.Bridge.1.Port.1",
                    "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.2.WANPPPConnection.1"
                ]
            }
        },
        {
            name: 'Host',
            type: 'text',
            required: false
        },
        {
            name: 'NumberOfRepetitions',
            type: 'int',
            options: {
                min: 1
            }
        },
        {
            name: 'Timeout',
            type: 'int',
            options: {
                min: 1
            }
        },
        {
            name: 'DataBlockSize',
            type: 'int',
            options: {
                min: 1,
                max: 65535
            }
        },
        {
            name: 'DSCP',
            type: 'int',
            options: {
                min: 0,
                max: 63
            }
        }
    ], group: 'Diagnostics', icon: 'ip-ping'
});
addBuiltInScript("Trace Route", {
    schema: [
        {
            name: 'Interface',
            type: 'combo',
            options: {
                items: [
                    "",
                    "Device.IP.Interface.1",
                    "Device.Bridge.1.Port.1",
                    "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.2.WANPPPConnection.1"
                ]
            }
        },
        {
            name: 'Host',
            type: 'text',
            required: false
        },
        {
            name: 'NumberOfRepetitions',
            type: 'int',
            options: {
                min: 1
            }
        },
        {
            name: 'Timeout',
            type: 'int',
            options: {
                min: 1
            }
        },
        {
            name: 'DataBlockSize',
            type: 'int',
            options: {
                min: 1,
                max: 65535
            }
        },
        {
            name: 'DSCP',
            type: 'int',
            options: {
                min: 0,
                max: 63
            }
        }
    ], group: 'Diagnostics', icon: 'trace-route'
});
addBuiltInScript("ATM Loopback", {
    schema: [
        {
            name: 'Interface',
            type: 'combo',
            options: {
                items: [
                    "Device.ATM.Link.1.",
                    "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1."
                ]
            },
            required: true
        },
        {
            name: 'NumberOfRepetitions',
            type: 'int'
        },
        {
            name: 'Timeout',
            type: 'int'
        }
    ], group: 'Diagnostics', icon: 'atm-loopback'
});
addBuiltInScript("ADSL Line Test", {
    schema: [
        {
            name: 'Interface',
            type: 'combo',
            options: {
                items: [
                    "Device.DSL.Channel.1.",
                    "InternetGatewayDevice.WANDevice.1."
                ]
            },
            required: true
        }
    ], group: 'Diagnostics', icon: 'adsl-line-test'
});
addBuiltInScript("IPTV Play", {
    schema: [
        {
            name: 'PlayURL',
            type: 'string',
            required: true
        }
    ], group: 'Diagnostics', icon: 'iptv-play'
});
addBuiltInScript("Self Test", {
    schema: [], group: 'Diagnostics', icon: 'self-test'
});
addBuiltInScript("NS Lookup", {
    schema: [
        {
            name: 'Interface',
            type: 'combo',
            options: {
                items: [
                    "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1."
                ]
            }
        },
        {
            name: 'HostName',
            type: 'string',
            required: true
        },
        {
            name: 'DNSServer',
            type: 'string'
        },
        {
            name: 'NumberOfRepetitions',
            type: 'int'
        },
        {
            name: 'Timeout',
            type: 'int'
        }
    ], group: 'Diagnostics', icon: 'ns-lookup'
});
addBuiltInScript("Download Diagnostics", {
    schema: [
        {
            name: 'Interface',
            type: 'combo',
            options: {
                items: [
                    "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1."
                ]
            }
        },
        {
            name: 'DownloadURL',
            type: 'string',
            required: true
        },
        {
            name: 'DSCP',
            type: 'int',
            options: {
                max: 63,
                min: 0
            }
        },
        {
            name: 'EthernetPriority',
            type: 'int',
            options: {
                max: 7,
                min: 0
            }
        }
    ], group: 'Diagnostics', icon: 'download'
});
addBuiltInScript("Upload Diagnostics", {
    schema: [
        {
            name: 'Interface',
            type: 'combo',
            options: {
                items: [
                    "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1."
                ]
            }
        },
        {
            name: 'UploadURL',
            type: 'string',
            required: true
        },
        {
            name: 'DSCP',
            type: 'int',
            options: {
                max: 63,
                min: 0
            }
        },
        {
            name: 'EthernetPriority',
            type: 'int',
            options: {
                max: 7,
                min: 0
            }
        },
        {
            name: 'TestFileLength',
            type: 'int',
            options: {
                min: 1
            }
        }
    ], group: 'Diagnostics', icon: 'upload'
});
addBuiltInScript("Firmware Upgrade", {
    schema: [
        {
            name: 'URL',
            type: 'text',
            required: false,
        },
        {
            name: 'Username',
            type: 'text',
            required: false,
        },
        {
            name: 'Password',
            type: 'text',
            required: false,
        }
    ], group: 'Diagnostics', icon: 'firmware-upgrade'
});
addBuiltInScript("Upload Log", {
    schema: [
        {
            name: 'FileType',
            type: 'combo',
            required: true,
            options: {
                url: API_PREFIX + '/device/vendor_log_file?device_name=${DEVICE_NAME}',
                recId: "id",
                recText: "text"
            },
        },
        {
            name: 'URL',
            type: 'text',
        },
        {
            name: 'Username',
            type: 'text',
        },
        {
            name: 'Password',
            type: 'text',
        },
    ], group: 'Diagnostics', icon: 'upload-log'
});
addBuiltInScript("Reboot", {group: 'Diagnostics', icon: 'reboot'});
addBuiltInScript("Factory Reset", {group: 'Diagnostics', icon: 'factory-reset'});
addBuiltInScript("Backup", {
    schema: [
        {
            name: 'FileType',
            type: 'combo',
            required: true,
            options: {
                url: API_PREFIX + '/device/vendor_config_file?device_name=${DEVICE_NAME}',
                recId: "id",
                recText: "text"
            },
        },
        {
            name: 'URL',
            type: 'text',
        },
        {
            name: 'Username',
            type: 'text',
        },
        {
            name: 'Password',
            type: 'text',
        },
    ], group: 'Diagnostics', icon: 'backup'
});
addBuiltInScript("Restore", {
    schema: [
        {
            name: 'URL',
            type: 'combo',
            required: true,
            options: {
                url: API_PREFIX + '/backup/read?device_name=${DEVICE_NAME}',
                recText: 'path',
                aslink: true,
            },
        },
        {
            name: 'Username',
            type: 'text',
        },
        {
            name: 'Password',
            type: 'text',
        },
    ], group: 'Diagnostics', icon: 'restore'
});
addBuiltInScript("Topology", {
    schema: [], group: 'Diagnostics', icon: 'topology'
});

addBuiltInScript("Auto Firmware Upgrade", {category: 'Generic', group: ''});
addBuiltInScript("Auto Upload Log", {category: 'Generic', group: ''});
addBuiltInScript("Auto Reboot", {category: 'Generic', group: ''});
addBuiltInScript("Auto Backup", {category: 'Generic', group: ''});
addBuiltInScript("Auto Sync Software", {category: 'Generic', group: ''});
addBuiltInScript("Temperature Memory CPU", {category: 'Generic', group: ''});


addBuiltInScript("Test Regression", {group: 'Test', icon: 'regression'});
addBuiltInScript("Test GetRPCMethods", {group: 'Test', icon: 'get_rpc_methods'});
addBuiltInScript("Test Reboot", {
    group: 'Test', icon: 'reboot', schema: [
        {
            field: 'CommandKey',
            html: {caption: 'Command key'},
            type: 'text',
            options: {
                max: 32,
            }
        },
    ]
});
addBuiltInScript("Test FactoryReset", {group: 'Test', icon: 'factory-reset'});
addBuiltInScript("Test SetParameterValues", {
    group: 'Test', icon: 'set_parameter_values', schema: [
        {
            field: 'ParameterKey',
            html: {caption: 'Parameter key'},
            type: 'text',
        },
        {
            field: 'Parameters',
            html: {caption: 'Parameters'},
            type: 'array',
            options: {
                fields: [
                    {
                        field: 'Name',
                        html: {caption: 'Name'},
                        type: 'combo',
                        options: {
                            items: "predefined_parameters"
                        },
                    },
                    {
                        field: 'Type',
                        html: {caption: 'Type'},
                        type: 'list',
                        options: {
                            items: ['string', 'int', 'unsignedInt', 'long', 'unsignedLong', 'boolean', 'dateTime', 'base64', 'hexBinary']
                        }
                    },
                    {
                        field: 'Value',
                        html: {caption: 'Value'},
                        type: 'text',
                    },
                ],
            },
        }
    ]
});
addBuiltInScript("Test GetParameterValues", {
    group: 'Test', icon: 'get_parameter_values', schema: [
        {
            field: 'Parameters',
            html: {caption: 'Parameters'},
            type: 'array',
            options: {
                simpleArray: true,
                fields: [
                    {
                        field: 'Name',
                        html: {caption: 'Name'},
                        type: 'combo',
                        options: {
                            items: "predefined_parameters_objects"
                        },
                    },
                ],
            },
        }
    ]
});
addBuiltInScript("Test GetParameterNames", {
    group: 'Test', icon: 'get_parameter_names', schema: [
        {
            field: 'Parameter',
            html: {caption: 'Parameter'},
            type: 'combo',
            options: {
                items: "w2ui_predefined_parameters_objects"
            },
        },
        {
            field: 'NextLevel',
            html: {caption: 'Next level'},
            type: 'toggle',
        }
    ]
});
addBuiltInScript("Test SetParameterAttributes", {
    group: 'Test', icon: 'set_parameter_attributes', schema: [
        {
            field: 'Parameters',
            html: {caption: 'Parameters'},
            type: 'array',
            options: {
                fields: [
                    {
                        field: 'Name',
                        html: {caption: 'Name'},
                        type: 'combo',
                        options: {
                            items: "predefined_parameters"
                        },
                    },
                    {
                        field: 'NotificationChange',
                        html: {caption: 'Notification change'},
                        type: 'toggle',
                    },
                    {
                        field: 'NotificationStr',
                        html: {caption: 'Notification'},
                        type: 'list',
                        options: {
                            items: [
                                "Off",
                                "Passive",
                                "Active",
                                "Passive lightweight",
                                "Passive + passive lightweight",
                                "Active lightweight",
                                "Passive + active lightweight",
                            ]
                        }
                    },
                    {
                        field: 'AccessListChange',
                        html: {caption: 'Access list change'},
                        type: 'toggle',
                    },
                    {
                        field: 'AccessListStr',
                        html: {caption: 'Access list'},
                        type: 'list',
                        options: {
                            items: [
                                "Subscriber",
                                "",
                            ]
                        }
                    },
                ],
            },
        }
    ]
});
addBuiltInScript("Test GetParameterAttributes", {
    group: 'Test', icon: 'get_parameter_attributes', schema: [
        {
            field: 'Parameters',
            html: {caption: 'Parameters'},
            type: 'array',
            options: {
                simpleArray: true,
                fields: [
                    {
                        field: 'Name',
                        html: {caption: 'Name'},
                        type: 'combo',
                        options: {
                            items: "predefined_parameters_objects"
                        },
                    },
                ],
            },
        }
    ]
});
addBuiltInScript("Test AddObject", {
    group: 'Test', icon: 'add_object', schema: [
        {
            field: 'ObjectName',
            html: {caption: 'Object name'},
            type: 'combo',
            required: true,
            options: {
                items: "w2ui_predefined_objects"
            }
        },
        {
            field: 'ParameterKey',
            html: {caption: 'Parameter key'},
            type: 'text',
        },
    ]
});
addBuiltInScript("Test DeleteObject", {
    group: 'Test', icon: 'delete_object', schema: [
        {
            field: 'ObjectName',
            html: {caption: 'Object name'},
            type: 'combo',
            required: true,
            options: {
                items: "w2ui_predefined_objects"
            }
        },
        {
            field: 'ParameterKey',
            html: {caption: 'Parameter key'},
            type: 'text',
        },
    ]
});
addBuiltInScript("Test Download", {
    group: 'Test', icon: 'download', schema: [
        {
            field: 'CommandKey',
            html: {caption: 'Command key'},
            type: 'text',
            options: {
                max: 32,
            }
        },
        {
            field: 'FileType',
            html: {caption: 'File type'},
            type: 'combo',
            required: true,
            options: {
                items: [
                    {
                        id: "1 Firmware Upgrade Image",
                        text: "1 Firmware Upgrade Image",
                    },
                    {
                        id: "2 Web Content",
                        text: "2 Web Content",
                    },
                    {
                        id: "3 Vendor Configuration File",
                        text: "3 Vendor Configuration File",
                    },
                    {
                        id: "4 Tone File",
                        text: "4 Tone File",
                    },
                    {
                        id: "5 Ringer File",
                        text: "5 Ringer File",
                    },
                ]
            }
        },
        {
            field: 'URL',
            html: {caption: 'URL'},
            type: 'text',
            required: true,
        },
        {
            field: 'Username',
            html: {caption: 'Username'},
            type: 'text',
        },
        {
            field: 'Password',
            html: {caption: 'Password'},
            type: 'text',
        },
        {
            field: 'FileSize',
            html: {caption: 'File size'},
            type: 'text',
        },
        {
            field: 'TargetFileName',
            html: {caption: 'Target file name'},
            type: 'text',
        },
        {
            field: 'DelaySeconds',
            html: {caption: 'Delay seconds'},
            type: 'int',
        },
    ]
});
addBuiltInScript("Test Upload", {
    group: 'Test', icon: 'upload', schema: [
        {
            field: 'CommandKey',
            html: {caption: 'Command key'},
            type: 'text',
            options: {
                max: 32,
            }
        },
        {
            field: 'FileType',
            html: {caption: 'File type'},
            type: 'combo',
            required: true,
            options: {
                items: [
                    {
                        id: "1 Vendor Configuration File",
                        text: "1 Vendor Configuration File",
                    },
                    {
                        id: "2 Vendor Log File",
                        text: "2 Vendor Log File",
                    },
                    {
                        id: "3 Vendor Configuration File <i>",
                        text: "3 Vendor Configuration File <i>",
                    },
                    {
                        id: "4 Vendor Log File <i>",
                        text: "4 Vendor Log File <i>",
                    },
                ]
            }
        },
        {
            field: 'URL',
            html: {caption: 'URL'},
            type: 'text',
        },
        {
            field: 'Username',
            html: {caption: 'Username'},
            type: 'text',
        },
        {
            field: 'Password',
            html: {caption: 'Password'},
            type: 'text',
        },
        {
            field: 'DelaySeconds',
            html: {caption: 'Delay seconds'},
            type: 'int',
        },
    ]
});
addBuiltInScript("Test GetQueuedTransfers", {group: 'Test', icon: 'get_queued_transfers'});
addBuiltInScript("Test GetAllQueuedTransfers", {group: 'Test', icon: 'get_all_queued_transfers'});
addBuiltInScript("Test CancelTransfer", {
    group: 'Test', icon: 'cancel_transfer', schema: [
        {
            field: 'CommandKey',
            html: {caption: 'Command key'},
            type: 'text',
            required: true,
        },
    ]
});
addBuiltInScript("Test ScheduleInform", {
    group: 'Test', icon: 'schedule_inform', schema: [
        {
            field: 'DelaySeconds',
            html: {caption: 'Delay seconds'},
            type: 'int',
            required: true,
        },
        {
            field: 'CommandKey',
            html: {caption: 'Command key'},
            type: 'text',
        },
    ]
});
addBuiltInScript("Test ScheduleDownload", {
    group: 'Test', icon: 'schedule_download', schema: [
        {
            field: 'CommandKey',
            html: {caption: 'Command key'},
            type: 'text',
            options: {
                max: 32,
            }
        },
        {
            field: 'FileType',
            html: {caption: 'File type'},
            type: 'combo',
            required: true,
            options: {
                items: [
                    {
                        id: "1 Firmware Upgrade Image",
                        text: "1 Firmware Upgrade Image",
                    },
                    {
                        id: "2 Web Content",
                        text: "2 Web Content",
                    },
                    {
                        id: "3 Vendor Configuration File",
                        text: "3 Vendor Configuration File",
                    },
                    {
                        id: "4 Tone File",
                        text: "4 Tone File",
                    },
                    {
                        id: "5 Ringer File",
                        text: "5 Ringer File",
                    },
                ]
            }
        },
        {
            field: 'URL',
            html: {caption: 'URL'},
            type: 'text',
            required: true,
            options: {
                max: 256,
            }
        },
        {
            field: 'Username',
            html: {caption: 'Username'},
            type: 'text',
            options: {
                max: 256,
            }
        },
        {
            field: 'Password',
            html: {caption: 'Password'},
            type: 'text',
            options: {
                max: 256,
            }
        },
        {
            field: 'FileSize',
            html: {caption: 'File size'},
            type: 'text',
            options: {
                min: 0,
            }
        },
        {
            field: 'TargetFileName',
            html: {caption: 'Target file name'},
            type: 'text',
            options: {
                max: 256,
            }
        },
        {
            field: 'TimeWindowList',
            html: {caption: 'Time window list'},
            type: 'array',
            required: true,
            options: {
                max: 2,
                fields: [
                    {
                        field: 'WindowStart',
                        html: {caption: 'Start'},
                        type: 'int',
                        options: {
                            min: 0,
                        }
                    },
                    {
                        field: 'WindowEnd',
                        html: {caption: 'End'},
                        type: 'int',
                        options: {
                            min: 0,
                        }
                    },
                    {
                        field: 'WindowMode',
                        html: {caption: 'Mode'},
                        type: 'list',
                        options: {
                            items: ['1 At Any Time', '2 Immediately', '3 When Idle', '4 Confirmation Needed'],
                        }
                    },
                    {
                        field: 'UserMessage',
                        html: {caption: 'User message'},
                        type: 'text',
                        options: {
                            max: 256,
                        }
                    },
                    {
                        field: 'MaxRetries',
                        html: {caption: 'Max retries'},
                        type: 'int',
                        options: {
                            min: -1,
                        }
                    },
                ],
            },
        }
    ]
});
addBuiltInScript("Test ChangeDUState", {
    group: 'Test', icon: 'change_du_state', schema: [
        {
            field: 'CommandKey',
            html: {caption: 'Command key'},
            type: 'text',
            options: {
                max: 32,
            }
        },
        {
            field: 'Install',
            html: {caption: 'Install'},
            type: 'array',
            options: {
                fields: [
                    {
                        field: 'URL',
                        html: {caption: 'URL'},
                        type: 'text',
                        required: true,
                        options: {
                            max: 1024,
                        }
                    },
                    {
                        field: 'UUID',
                        html: {caption: 'UUID'},
                        type: 'text',
                        options: {
                            max: 36,
                        }
                    },
                    {
                        field: 'Username',
                        html: {caption: 'Username'},
                        type: 'text',
                        options: {
                            max: 256,
                        }
                    },
                    {
                        field: 'Password',
                        html: {caption: 'Password'},
                        type: 'text',
                        options: {
                            max: 256,
                        }
                    },
                    {
                        field: 'ExecutionEnvRef',
                        html: {caption: 'Execution env'},
                        type: 'combo',
                        options: {
                            items: ["Device.SoftwareModules.ExecEnv.{i}.", "InternetGatewayDevice.SoftwareModules.ExecEnv.{i}."]
                        }
                    },
                ],
            },
        },
        {
            field: 'Update',
            html: {caption: 'Update'},
            type: 'array',
            options: {
                fields: [
                    {
                        field: 'UUID',
                        html: {caption: 'UUID'},
                        type: 'text',
                        options: {
                            max: 36,
                        }
                    },
                    {
                        field: 'Version',
                        html: {caption: 'Version'},
                        type: 'text',
                        options: {
                            max: 36,
                        }
                    },
                    {
                        field: 'URL',
                        html: {caption: 'URL'},
                        type: 'text',
                        options: {
                            max: 1024,
                        }
                    },
                    {
                        field: 'Username',
                        html: {caption: 'Username'},
                        type: 'text',
                        options: {
                            max: 256,
                        }
                    },
                    {
                        field: 'Password',
                        html: {caption: 'Password'},
                        type: 'text',
                        options: {
                            max: 256,
                        }
                    },
                ],
            },
        },
        {
            field: 'Uninstall',
            html: {caption: 'Uninstall'},
            type: 'array',
            options: {
                fields: [
                    {
                        field: 'UUID',
                        html: {caption: 'UUID'},
                        type: 'text',
                        options: {
                            max: 36,
                        }
                    },
                    {
                        field: 'Version',
                        html: {caption: 'Version'},
                        type: 'text',
                        options: {
                            max: 36,
                        }
                    },
                    {
                        field: 'ExecutionEnvRef',
                        html: {caption: 'Execution env'},
                        type: 'combo',
                        options: {
                            items: ["Device.SoftwareModules.ExecEnv.{i}.", "InternetGatewayDevice.SoftwareModules.ExecEnv.{i}."]
                        }
                    },
                ],
            },
        },
    ]
});


addBuiltInScript("Inspect Service", {
    schema: [
        {
            name: 'Service',
            type: 'list',
            required: true,
            options: {
                url: API_PREFIX + '/subscription/read?subscriber_id=${SUBSCRIBER_ID}',
                recText: 'service_name',
            },
        },
    ], group: 'Diagnostics', protocol: 'OMADM', icon: 'inspect'
});
addBuiltInScript("Enable Service", {
    schema: [
        {
            name: 'Service',
            type: 'list',
            required: true,
            options: {
                url: API_PREFIX + '/subscription/read?subscriber_id=${SUBSCRIBER_ID}&enable=true',
                recText: 'service_name',
            },
        },
    ], group: 'Diagnostics', protocol: 'OMADM', icon: 'enable'
});
addBuiltInScript("Disable Service", {
    schema: [
        {
            name: 'Service',
            type: 'list',
            required: true,
            options: {
                url: API_PREFIX + '/subscription/read?subscriber_id=${SUBSCRIBER_ID}&enable=false',
                recText: 'service_name',
            },
        },
    ], group: 'Diagnostics', protocol: 'OMADM', icon: 'disable'
});
addBuiltInScript("Test Get", {
    group: 'Test', protocol: 'OMADM', icon: 'get_parameter_values', schema: [
        {
            field: 'Parameters',
            html: {caption: 'Parameters'},
            type: 'array',
            options: {
                simpleArray: true,
                fields: [
                    {
                        field: 'Name',
                        html: {caption: 'Name'},
                        type: 'combo',
                        options: {
                            items: "omadm_predefined_parameters_objects"
                        },
                    },
                ],
            },
        }
    ]
});
addBuiltInScript("Test Replace", {
    group: 'Test', protocol: 'OMADM', icon: 'set_parameter_values', schema: [
        {
            field: 'Parameters',
            html: {caption: 'Parameters'},
            type: 'array',
            options: {
                fields: [
                    {
                        field: 'Name',
                        html: {caption: 'Name'},
                        type: 'combo',
                        required: true,
                        options: {
                            items: "omadm_predefined_parameters"
                        },
                    },
                    {
                        field: 'Format',
                        html: {caption: 'Format'},
                        type: 'list',
                        options: {
                            items: [
                                "chr", //chr as the default format
                                "b64",
                                "bool",
                                "date",
                                "float",
                                "int",
                                "node",
                                "null",
                                "time",
                                "xml"
                            ]
                        },
                    },
                    {
                        field: 'Type',
                        html: {caption: 'Type'},
                        type: 'text',
                    },
                    {
                        field: 'Value',
                        html: {caption: 'Value'},
                        type: 'text',
                    }
                ],
            },
        }
    ]
});
addBuiltInScript("Test Exec", {
    group: 'Test', protocol: 'OMADM', icon: 'exec', schema: [
        {
            field: 'Name',
            html: {caption: 'Name'},
            type: 'combo',
            options: {
                items: "omadm_predefined_parameters_objects"
            }
        }
    ]
});
addBuiltInScript("Test Add", {
    group: 'Test', protocol: 'OMADM', icon: 'add_object', schema: [
        {
            field: 'Parameters',
            html: {caption: 'Parameters'},
            type: 'array',
            options: {
                fields: [
                    {
                        field: 'Name',
                        html: {caption: 'Name'},
                        type: 'combo',
                        required: true,
                        options: {
                            items: "omadm_predefined_parameters_objects"
                        },
                    },
                    {
                        field: 'Format',
                        html: {caption: 'Format'},
                        type: 'list',
                        options: {
                            items: [
                                "chr", // chr as the default format
                                "b64",
                                "bool",
                                "date",
                                "float",
                                "int",
                                "node",
                                "null",
                                "time",
                                "xml"
                            ]
                        },
                    },
                    {
                        field: 'Type',
                        html: {caption: 'Type'},
                        type: 'text',
                    },
                    {
                        field: 'Value',
                        html: {caption: 'Value'},
                        type: 'text',
                    }
                ],
            },
        }
    ]
});
addBuiltInScript("Test Delete", {
    group: 'Test', protocol: 'OMADM', icon: 'delete_object', schema: [
        {
            field: 'Parameters',
            html: {caption: 'Parameters'},
            type: 'array',
            options: {
                simpleArray: true,
                fields: [
                    {
                        field: 'Name',
                        html: {caption: 'Name'},
                        type: 'combo',
                        options: {
                            items: "omadm_predefined_parameters_objects"
                        },
                    },
                ],
            },
        }
    ]
});
addBuiltInScript("Test Copy", {
    group: 'Test', protocol: 'OMADM', icon: 'copy', schema: [
        {
            field: 'From',
            html: {caption: 'From'},
            type: 'combo',
            options: {
                items: "omadm_predefined_parameters_objects"
            }
        },
        {
            field: 'To',
            html: {caption: 'To'},
            type: 'combo',
            options: {
                items: "omadm_predefined_parameters_objects"
            }
        }
    ]
});
addBuiltInScript("Test Display", {
    group: 'Test', protocol: 'OMADM', icon: 'display', schema: [
        {
            field: 'Message',
            html: {caption: 'Message'},
            type: 'text',
        },
        {
            field: 'MINDT',
            html: {caption: 'Minimal display time'},
            type: 'int',
            options: {
                min: 0
            }
        },
        {
            field: 'MAXDT',
            html: {caption: 'Maximum display time'},
            type: 'int',
            options: {
                min: 0
            }
        }
    ]
});
addBuiltInScript("Test Confirm", {
    group: 'Test', protocol: 'OMADM', icon: 'confirm', schema: [
        {
            field: 'Message',
            html: {caption: 'Message'},
            type: 'text',
        },
        {
            field: 'MINDT',
            html: {caption: 'Minimal display time'},
            type: 'int',
            options: {
                min: 0
            }
        },
        {
            field: 'MAXDT',
            html: {caption: 'Maximum display time'},
            type: 'int',
            options: {
                min: 0
            }
        },
        {
            field: 'DR',
            html: {caption: 'Default response'},
            type: 'toggle'
        }
    ]
});
addBuiltInScript("Test Input", {
    group: 'Test', protocol: 'OMADM', icon: 'input', schema: [
        {
            field: 'Message',
            html: {caption: 'Message'},
            type: 'text'
        },
        {
            field: 'DR',
            html: {caption: 'Default response'},
            type: 'text',
        },
        {
            field: 'MINDT',
            html: {caption: 'Minimal display time'},
            type: 'int',
            options: {
                min: 0
            }
        },
        {
            field: 'MAXDT',
            html: {caption: 'Maximum display time'},
            type: 'int',
            options: {
                min: 0
            }
        },
        {
            field: 'MAXLEN',
            html: {caption: 'Maximum length'},
            type: 'int',
            options: {
                min: 0
            }
        },
        {
            field: 'IT',
            html: {caption: 'Input type'},
            type: 'list',
            options: {
                items: [
                    {
                        id: 'A',
                        text: 'Alphanumeric'
                    },
                    {
                        id: 'N',
                        text: 'Numeric'
                    },
                    {
                        id: 'D',
                        text: 'Date'
                    },
                    {
                        id: 'T',
                        text: 'Time'
                    },
                    {
                        id: 'P',
                        text: 'Phone number'
                    },
                    {
                        id: 'I',
                        text: 'IP address'
                    }
                ]
            }
        },
        {
            field: 'ET',
            html: {caption: 'Echo type'},
            type: 'list',
            options: {
                items: [
                    {
                        id: 'T',
                        text: 'Text'
                    },
                    {
                        id: 'P',
                        text: 'Password'
                    }
                ]
            }
        }
    ]
});
addBuiltInScript("Test Single Choice", {
    group: 'Test', protocol: 'OMADM', icon: 'single_choice', schema: [
        {
            field: 'Message',
            html: {caption: 'Message'},
            type: 'text',
        },
        {
            field: 'Options',
            html: {caption: 'Options'},
            type: 'array',
            options: {
                simpleArray: true,
                fields: [
                    {
                        field: 'Option',
                        html: {caption: 'Option'},
                        type: 'text'
                    }
                ]
            }
        },
        {
            field: 'MINDT',
            html: {caption: 'Minimal display time'},
            type: 'int',
            options: {
                min: 0
            }
        },
        {
            field: 'MAXDT',
            html: {caption: 'Maximum display time'},
            type: 'int',
            options: {
                min: 0
            }
        },
        {
            field: 'DR',
            html: {caption: 'Default response'},
            type: 'number',
            options: {
                min: 1
            }
        }
    ]
});
addBuiltInScript("Test Multi Choice", {
    group: 'Test', protocol: 'OMADM', icon: 'multi_choice', schema: [
        {
            field: 'Message',
            html: {caption: 'Message'},
            type: 'text',
        },
        {
            field: 'Options',
            html: {caption: 'Options'},
            type: 'array',
            options: {
                simpleArray: true,
                fields: [
                    {
                        field: 'Option',
                        html: {caption: 'Option'},
                        type: 'text'
                    }
                ]
            }
        },
        {
            field: 'MINDT',
            html: {caption: 'Minimal display time'},
            type: 'int',
            options: {
                min: 0
            }
        },
        {
            field: 'MAXDT',
            html: {caption: 'Maximum display time'},
            type: 'int',
            options: {
                min: 0
            }
        },
        {
            field: 'DR',
            html: {caption: 'Default response'},
            type: 'text'
        }
    ]
});
addBuiltInScript("Test Regression", {protocol: 'OMADM', group: 'Test', icon: 'regression'});
addBuiltInScript("Firmware Upgrade", {
    protocol: 'OMADM', schema: [
        {
            name: 'URL',
            type: 'text',
            required: false,
        }
    ], group: 'Diagnostics', icon: 'firmware-upgrade'
});
addBuiltInScript("Factory Reset", {group: 'Diagnostics', icon: 'factory-reset', protocol: 'OMADM'});
addBuiltInScript("Lock", {group: 'Diagnostics', icon: 'lock', protocol: 'OMADM'});
addBuiltInScript("Unlock", {group: 'Diagnostics', icon: 'unlock', protocol: 'OMADM'});
addBuiltInScript("Wipe", {group: 'Diagnostics', icon: 'wipe', protocol: 'OMADM'});
addBuiltInScript("Auto Firmware Upgrade", {category: 'Generic', group: '', protocol: 'OMADM'});


addBuiltInScript("CPU Stats", {category: 'Generic', group: '', protocol: 'SNMP'});
addBuiltInScript("Disk Stats", {category: 'Generic', group: '', protocol: 'SNMP'});
addBuiltInScript("Memory Stats", {category: 'Generic', group: '', protocol: 'SNMP'});
addBuiltInScript("Network Stats", {category: 'Generic', group: '', protocol: 'SNMP'});
addBuiltInScript("Process Stats", {category: 'Generic', group: '', protocol: 'SNMP'});

addBuiltInScript("Reboot", {category: 'Action', protocol: 'LwM2M', group: 'Diagnostics', icon: 'reboot'});
addBuiltInScript("Auto Reboot", {category: 'Generic', protocol: 'LwM2M', group: ''});


//Initialize service
db.service.createIndex({name: 1}, {unique: true})

//Initialize subscriber
db.subscriber.createIndex({name: 1})
db.subscriber.createIndex({subscriber_id: 1}, {unique: true})
db.subscriber.createIndex({binding_key: 1}, {unique: true, sparse: true})
db.subscriber.createIndex({phone_number: 1})
db.subscriber.createIndex({email: 1})
db.subscriber.createIndex({domain: 1})
db.subscriber.createIndex({tags: 1})

//Initialize subscription
db.subscription.createIndex({service_name: 1, subscriber_id: 1}, {unique: true})
db.subscription.createIndex({subscriber_id: 1, enable: 1, enabled_devices: 1})
db.subscription.createIndex({subscriber_name: 1})
db.subscription.createIndex({enabled_devices: 1})
db.subscription.createIndex({enable: 1})
db.subscription.createIndex({domain: 1})


//Initialize order
db.order.createIndex({order_id: 1, subscriber_id: 1, service_name: 1}, {unique: true})
db.order.createIndex({service_name: 1, subscriber_id: 1})
db.order.createIndex({subscriber_name: 1})
db.order.createIndex({subscriber_id: 1})
db.order.createIndex({domain: 1})
db.order.createIndex({tags: 1})
db.order.createIndex({create_time: 1})

//Initialize firmware
db.firmware.createIndex({version_number: 1, oui: 1, product_class: 1}, {unique: true})
db.firmware.createIndex({protocol: 1})

//Initialize scheduler
db.scheduler.createIndex({name: 1}, {unique: true})

//Initialize event
db.event.createIndex({name: 1}, {unique: true})
db.event.createIndex({event: 1, time_scope: 1})

//Initialize backup
db.backup.createIndex({path: 1}, {unique: true})
db.backup.createIndex({device_name: 1})
db.backup.createIndex({create_time: 1})
db.backup.createIndex({file_type: 1})
db.backup.createIndex({domain: 1})
db.backup.createIndex({uuid: 1})


//Initialize device_log
db.device_log.createIndex({path: 1}, {unique: true})
db.device_log.createIndex({device_name: 1})
db.device_log.createIndex({create_time: 1})
db.device_log.createIndex({file_type: 1})
db.device_log.createIndex({domain: 1})
db.device_log.createIndex({uuid: 1})

//Initialize software
db.software.createIndex({uuid: 1, version_number: 1}, {unique: true})
db.software.createIndex({name: 1})
db.software.createIndex({vendor: 1})

//Initialize test case
db.test_case.createIndex({device_name: 1})
db.test_case.createIndex({name: 1})
db.test_case.createIndex({status: 1})
db.test_case.createIndex({create_time: 1})
db.test_case.createIndex({complete_time: 1})
db.test_case.createIndex({domain: 1})

//Initialize alarm
db.alarm.createIndex({cleared: 1, cleared_time: 1, device_name: 1, identifier: 1})
db.alarm.createIndex({perceived_severity: 1}, {sparse: true})
db.alarm.createIndex({create_time: 1})
db.alarm.createIndex({raised_time: 1})
db.alarm.createIndex({device_name: 1})
db.alarm.createIndex({domain: 1})

//Initialize generic script monitor detail
db.generic_detail.createIndex({script: 1, domain: 1})
db.generic_detail.createIndex({device_name: 1})
db.generic_detail.createIndex({create_time: 1})

//Initialize generic script failure
db.generic_failure.createIndex({script: 1, domain: 1})
db.generic_failure.createIndex({device_name: 1})
db.generic_failure.createIndex({create_time: 1})

//Initialize lte_pm
db.lte_pm.createIndex({devie_name: 1})
db.lte_pm.createIndex({domain: 1})
db.lte_pm.createIndex({begin_time: 1})

//Initialize thing
db.thing.createIndex({device_name: 1, slot: 1, addr: 1}, {unique: 1})
db.thing.createIndex({group: 1, name: 1}, {unique: 1, sparse: 1})
db.thing.createIndex({model: 1})
db.thing.createIndex({vendor: 1})
db.thing.createIndex({domain: 1})
db.thing.createIndex({tags: 1})

//Initialize thing_data
db.thing_data.createIndex({device_name: 1, slot: 1, addr: 1, create_time: 1}, {unique: true})
db.thing_data.createIndex({domain: 1})
db.thing_data_hour.createIndex({device_name: 1, slot: 1, addr: 1, create_time: 1}, {unique: true})
db.thing_data_hour.createIndex({domain: 1})


//Initialize chat
db.group_chat.createIndex({name: 1})
db.group_chat.createIndex({members: 1})

//Initialize chat message
db.chat_message.createIndex({create_time: 1})
db.chat_message.createIndex({sender_id: 1, group: 1})
db.chat_message.createIndex({receiver_id: 1, group: 1})
db.chat_message.createIndex({receiver_id: 1, sender_id: 1})


//Initialize dmt
db.dmt.createIndex({device_name: 1}, {unique: 1})

//Network failure
db.network_failure.createIndex({fixed: 1, parent: 1})
db.network_failure.createIndex({domain: 1})


//Validation error
db.validation_error.createIndex({device_name: 1})
db.validation_error.createIndex({create_time: 1})
db.validation_error.createIndex({level: 1})

//System alarm
db.sys_alarm.createIndex({mid: 1, cleared: 1, probable_cause: 1})
db.sys_alarm.createIndex({create_time: 1})
db.sys_alarm.createIndex({cleared_time: 1})
db.sys_alarm.createIndex({node_name: 1})
db.sys_alarm.createIndex({severity: 1})
