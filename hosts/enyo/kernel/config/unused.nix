{lib, ...}: let
  inherit (lib.kernel) no unset;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkForce;
in {
  boot.kernelPatches = [
    {
      name = "disable-unused-features";
      patch = null;
      extraStructuredConfig = mapAttrs (_: mkForce) {
        CONFIG_ATALK = no;
        CONFIG_BATMAN_ADV = no;
        CONFIG_CAIF = no;
        CONFIG_COMEDI = no;
        CONFIG_DVB_CORE = no;
        CONFIG_FB_TFT = no;
        CONFIG_IIO = no;
        CONFIG_INPUT_TOUCHSCREEN = no;
        CONFIG_NFC = no;
        CONFIG_SND_FIREWIRE = unset;
        CONFIG_USB_GSPCA = no;
        CONFIG_USB_SERIAL = no;
        CONFIG_USB_SERIAL_CONSOLE = unset;
        CONFIG_USB_SERIAL_GENERIC = unset;
        CONFIG_WATCHDOG = no;
        CONFIG_WATCHDOG_SYSFS = unset;
        CONFIG_XEN = no;

        CONFIG_CRYPTO_842 = no;
        CONFIG_DEBUG_MISC = no;
        CONFIG_DEBUG_PREEMPT = no;
        CONFIG_HIBERNATION = no;
        CONFIG_KEXEC = no;
        CONFIG_KEXEC_FILE = no;

        CONFIG_60XX_WDT = no;
        CONFIG_6LOWPAN = no;
        CONFIG_8139CP = no;
        CONFIG_8139TOO = no;
        CONFIG_8139TOO_8129 = no;

        CONFIG_ALIENWARE_WMI = no;
        CONFIG_ALIM1535_WDT = no;
        CONFIG_ALIM7101_WDT = no;
        CONFIG_ALTERA_MBOX = no;
        CONFIG_ALTERA_MSGDMA = no;
        CONFIG_ALTERA_TSE = no;
        CONFIG_ALX = no;

        CONFIG_GENERIC_ADC_BATTERY = no;
        CONFIG_IP5XXX_POWER = no;
        CONFIG_TEST_POWER = no;
        CONFIG_CHARGER_ADP5061 = no;
        CONFIG_BATTERY_CW2015 = no;
        CONFIG_BATTERY_DS2760 = no;
        CONFIG_BATTERY_DS2780 = no;
        CONFIG_BATTERY_DS2781 = no;
        CONFIG_BATTERY_DS2782 = no;
        CONFIG_BATTERY_SAMSUNG_SDI = no;
        CONFIG_BATTERY_SBS = no;
        CONFIG_CHARGER_SBS = no;
        CONFIG_MANAGER_SBS = no;
        CONFIG_BATTERY_BQ27XXX = no;
        CONFIG_BATTERY_BQ27XXX_I2C = no;
        CONFIG_BATTERY_BQ27XXX_HDQ = no;
        CONFIG_BATTERY_BQ27XXX_DT_UPDATES_NVM = no;
        CONFIG_CHARGER_DA9150 = no;
        CONFIG_BATTERY_AXP20X = no;
        CONFIG_AXP20X_POWER = no;
        CONFIG_AXP288_CHARGER = no;
        CONFIG_AXP288_FUEL_GAUGE = no;
        CONFIG_BATTERY_MAX17040 = no;
        CONFIG_BATTERY_MAX17042 = no;
        CONFIG_BATTERY_MAX1721X = no;
        CONFIG_CHARGER_PCF50633 = no;
        CONFIG_CHARGER_ISP1704 = no;
        CONFIG_CHARGER_MAX8903 = no;
        CONFIG_CHARGER_LP8727 = no;
        CONFIG_CHARGER_GPIO = no;
        CONFIG_CHARGER_MANAGER = no;
        CONFIG_CHARGER_LT3651 = no;
        CONFIG_CHARGER_LTC4162L = no;
        CONFIG_CHARGER_MAX14577 = no;
        CONFIG_CHARGER_MAX77693 = no;
        CONFIG_CHARGER_MAX77976 = no;
        CONFIG_CHARGER_MP2629 = no;
        CONFIG_CHARGER_MT6360 = no;
        CONFIG_CHARGER_MT6370 = no;
        CONFIG_CHARGER_BQ2415X = no;
        CONFIG_CHARGER_BQ24190 = no;
        CONFIG_CHARGER_BQ24257 = no;
        CONFIG_CHARGER_BQ24735 = no;
        CONFIG_CHARGER_BQ2515X = no;
        CONFIG_CHARGER_BQ25890 = no;
        CONFIG_CHARGER_BQ25980 = no;
        CONFIG_CHARGER_BQ256XX = no;
        CONFIG_CHARGER_SMB347 = no;
        CONFIG_BATTERY_GAUGE_LTC2941 = no;
        CONFIG_BATTERY_GOLDFISH = no;
        CONFIG_BATTERY_RT5033 = no;
        CONFIG_CHARGER_RT5033 = no;
        CONFIG_CHARGER_RT9455 = no;
        CONFIG_CHARGER_RT9467 = no;
        CONFIG_CHARGER_RT9471 = no;
        CONFIG_CHARGER_CROS_USBPD = no;
        CONFIG_CHARGER_CROS_PCHG = no;
        CONFIG_CHARGER_BD99954 = no;
        CONFIG_CHARGER_WILCO = no;
        CONFIG_BATTERY_SURFACE = no;
        CONFIG_CHARGER_SURFACE = no;
        CONFIG_BATTERY_UG3105 = no;
        CONFIG_FUEL_GAUGE_MM8013 = no;

        CONFIG_GENERIC_IRQ_DEBUGFS = no;

        # Remove samba support
        CONFIG_CIFS = no;
        CONFIG_CIFS_ROOT = no;

        # Disable AMDGPU CIK support
        CONFIG_DRM_AMDGPU_CIK = no;

        # Disable radeon drivers
        CONFIG_DRM_RADEON = no;
        CONFIG_FB_RADEON = no;
        CONFIG_FB_RADEON_I2C = no;
        CONFIG_FB_RADEON_BACKLIGHT = no;

        # Disable ngreedia drivers
        CONFIG_NET_VENDOR_NVIDIA = no;
        CONFIG_I2C_NVIDIA_GPU = no;
        CONFIG_FB_NVIDIA = no;
        CONFIG_FB_NVIDIA_I2C = no;
        CONFIG_FB_NVIDIA_BACKLIGHT = no;
        CONFIG_HID_NVIDIA_SHIELD = no;
        CONFIG_TYPEC_NVIDIA_ALTMODE = no;
        CONFIG_NVIDIA_WMI_EC_BACKLIGHT = no;

        # Firewire
        CONFIG_FIREWIRE = no;
        CONFIG_FIREWIRE_OHCI = no;
        CONFIG_FIREWIRE_SBP2 = no;
        CONFIG_FIREWIRE_NET = no;
        CONFIG_FIREWIRE_NOSY = no;

        # MS surface HID
        CONFIG_SURFACE_AGGREGATOR = no;

        CONFIG_DELL_RBTN = no;
        CONFIG_DELL_RBU = no;
        CONFIG_DELL_SMBIOS = no;
        CONFIG_DELL_WMI = no;
        CONFIG_DELL_WMI_AIO = no;
        CONFIG_DELL_WMI_DESCRIPTOR = no;
        CONFIG_DELL_WMI_LED = no;
        CONFIG_DELL_WMI_SYSMAN = no;

        CONFIG_HID_A4TECH = no;
        CONFIG_HID_ACRUX = no;
        CONFIG_HID_ALPS = no;
        CONFIG_HID_APPLEIR = no;
        CONFIG_HID_ASUS = no;
        CONFIG_HID_AUREAL = no;
        CONFIG_HID_BETOP_FF = no;
        CONFIG_HID_BIGBEN_FF = no;
        CONFIG_HID_CMEDIA = no;
        CONFIG_HID_COUGAR = no;
        CONFIG_HID_CREATIVE_SB0540 = no;
        CONFIG_HID_CYPRESS = no;
        CONFIG_HID_DRAGONRISE = no;
        CONFIG_HID_ELAN = no;
        CONFIG_HID_ELECOM = no;
        CONFIG_HID_ELO = no;
        CONFIG_HID_EMS_FF = no;
        CONFIG_HID_EZKEY = no;
        CONFIG_HID_GEMBIRD = no;
        CONFIG_HID_GFRM = no;
        CONFIG_HID_GOOGLE_HAMMER = no;
        CONFIG_HID_GREENASIA = no;
        CONFIG_HID_GT683R = no;
        CONFIG_HID_GYRATION = no;
        CONFIG_HID_HOLTEK = no;
        CONFIG_HID_HYPERV_MOUSE = no;
        CONFIG_HID_ICADE = no;
        CONFIG_HID_ITE = no;
        CONFIG_HID_KEYTOUCH = no;
        CONFIG_HID_KYE = no;
        CONFIG_HID_LCPOWER = no;
        CONFIG_HID_LED = no;
        CONFIG_HID_MALTRON = no;
        CONFIG_HID_MCP2221 = no;
        CONFIG_HID_MONTEREY = no;
        CONFIG_HID_MULTITOUCH = no;
        CONFIG_HID_NTI = no;
        CONFIG_HID_NTRIG = no;
        CONFIG_HID_PANTHERLORD = no;
        CONFIG_HID_PENMOUNT = no;
        CONFIG_HID_PETALYNX = no;
        CONFIG_HID_PICOLCD = no;
        CONFIG_HID_PLAYSTATION = no;
        CONFIG_HID_PRIMAX = no;
        CONFIG_HID_REDRAGON = no;
        CONFIG_HID_RETRODE = no;
        CONFIG_HID_RMI = no;
        CONFIG_HID_RMI4 = no;
        CONFIG_HID_SAITEK = no;
        CONFIG_HID_SAMSUNG = no;
        CONFIG_HID_SEMITEK = no;
        CONFIG_HID_SMARTJOYPLUS = no;
        CONFIG_HID_SONY = no;
        CONFIG_HID_SPEEDLINK = no;
        CONFIG_HID_SUNPLUS = no;
        CONFIG_HID_THINGM = no;
        CONFIG_HID_THRUSTMASTER = no;
        CONFIG_HID_TIVO = no;
        CONFIG_HID_TOPSEED = no;
        CONFIG_HID_TWINHAN = no;
        CONFIG_HID_U2FZERO = no;
        CONFIG_HID_UCLOGIC = no;
        CONFIG_HID_UDRAW_PS3 = no;
        CONFIG_HID_VIEWSONIC = no;
        CONFIG_HID_VIVALDI = no;
        CONFIG_HID_WALTOP = no;
        CONFIG_HID_WIIMOTE = no;
        CONFIG_HID_XINMO = no;
        CONFIG_HID_ZEROPLUS = no;
        CONFIG_HID_ZYDACRON = no;

        # disable unused soc modules
        CONFIG_SND_SOC_CHV3_I2S = no;
        CONFIG_SND_SOC_ADI = no;
        CONFIG_SND_SOC_APPLE_MCA = no;
        CONFIG_SND_ATMEL_SOC = no;
        CONFIG_SND_DESIGNWARE_I2S = no;
        CONFIG_SND_SOC_FSL_ASRC = no;
        CONFIG_SND_SOC_FSL_SAI = no;
        CONFIG_SND_SOC_FSL_MQS = no;
        CONFIG_SND_SOC_FSL_AUDMIX = no;
        CONFIG_SND_SOC_FSL_SSI = no;
        CONFIG_SND_SOC_FSL_SPDIF = no;
        CONFIG_SND_SOC_FSL_ESAI = no;
        CONFIG_SND_SOC_FSL_MICFIL = no;
        CONFIG_SND_SOC_FSL_EASRC = no;
        CONFIG_SND_SOC_FSL_XCVR = no;
        CONFIG_SND_SOC_FSL_UTILS = no;
        CONFIG_SND_SOC_FSL_RPMSG = no;
        CONFIG_SND_I2S_HI6210_I2S = no;
        CONFIG_SND_SOC_IMG = no;
        CONFIG_SND_SOC_STI = no;
        CONFIG_SND_SOC_XILINX_I2S = no;
        CONFIG_SND_SOC_XILINX_AUDIO_FORMATTER = no;
        CONFIG_SND_SOC_XILINX_SPDIF = no;
        CONFIG_SND_XEN_FRONTEND = no;

        CONFIG_INFINIBAND = no;
        CONFIG_INFINIBAND_IPOIB = unset;
        CONFIG_INFINIBAND_IPOIB_CM = unset;
        CONFIG_NET_DSA = no;
        CONFIG_NET_VENDOR_CISCO = no;
        CONFIG_NET_VENDOR_HUAWEI = no;
        CONFIG_NET_VENDOR_MARVELL = no;
        CONFIG_NET_VENDOR_MELLANOX = no;
        CONFIG_NET_VENDOR_RENESAS = no;
        CONFIG_NET_VENDOR_STMICRO = no;
        CONFIG_RT2800USB_RT53XX = unset;
        CONFIG_RT2800USB_RT55XX = unset;
        CONFIG_WLAN_VENDOR_MARVELL = no;
        CONFIG_WLAN_VENDOR_MEDIATEK = no;
        CONFIG_WLAN_VENDOR_RALINK = no;
        CONFIG_X25 = no;

        CONFIG_AFFS_FS = no;
        CONFIG_AFS_FS = no;
        CONFIG_BEFS_FS = no;
        CONFIG_CODA_FS = no;
        CONFIG_JFS_FS = no;
        CONFIG_OCFS2_FS = no;
        CONFIG_OMFS_FS = no;
        CONFIG_ORANGEFS_FS = no;
        CONFIG_SYSV_FS = no;

        CONFIG_CHROME_PLATFORMS = no;
        CONFIG_CHROMEOS_LAPTOP = unset;
        CONFIG_CHROMEOS_PSTORE = unset;
        CONFIG_CHROMEOS_TBMC = unset;
        CONFIG_CROS_EC = unset;
        CONFIG_CROS_EC_I2C = unset;
        CONFIG_CROS_EC_ISHTP = unset;
        CONFIG_CROS_EC_LPC = unset;
        CONFIG_CROS_EC_SPI = unset;
        CONFIG_CROS_KBD_LED_BACKLIGHT = unset;

        CONFIG_SND_SOC = no;
        CONFIG_SND_SOC_INTEL_SOUNDWIRE_SOF_MACH = unset;
        CONFIG_SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES = unset;
        CONFIG_SND_SOC_SOF_ACPI = unset;
        CONFIG_SND_SOC_SOF_APOLLOLAKE = unset;
        CONFIG_SND_SOC_SOF_CANNONLAKE = unset;
        CONFIG_SND_SOC_SOF_COFFEELAKE = unset;
        CONFIG_SND_SOC_SOF_COMETLAKE = unset;
        CONFIG_SND_SOC_SOF_ELKHARTLAKE = unset;
        CONFIG_SND_SOC_SOF_GEMINILAKE = unset;
        CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC = unset;
        CONFIG_SND_SOC_SOF_HDA_LINK = unset;
        CONFIG_SND_SOC_SOF_ICELAKE = unset;
        CONFIG_SND_SOC_SOF_INTEL_TOPLEVEL = unset;
        CONFIG_SND_SOC_SOF_JASPERLAKE = unset;
        CONFIG_SND_SOC_SOF_MERRIFIELD = unset;
        CONFIG_SND_SOC_SOF_PCI = unset;
        CONFIG_SND_SOC_SOF_TIGERLAKE = unset;
        CONFIG_SND_SOC_SOF_TOPLEVEL = unset;

        CONFIG_HUAWEI_WMI = no;
      };
    }
  ];
}
