# Clock and Reset
set_property PACKAGE_PIN J19 [get_ports CLK_50M]
set_property PACKAGE_PIN L18 [get_ports RESET_N]

set_property IOSTANDARD LVCMOS33 [get_ports CLK_50M]
set_property IOSTANDARD LVCMOS33 [get_ports RESET_N]

# KEY
set_property PACKAGE_PIN AA1 [get_ports KEY1]
set_property PACKAGE_PIN W1  [get_ports KEY2]

set_property IOSTANDARD LVCMOS33 [get_ports KEY1]
set_property IOSTANDARD LVCMOS33 [get_ports KEY2]

# LED
set_property PACKAGE_PIN M18 [get_ports LED1]
set_property PACKAGE_PIN N18 [get_ports LED2]

set_property IOSTANDARD LVCMOS33 [get_ports LED1]
set_property IOSTANDARD LVCMOS33 [get_ports LED2]

# HDMI
set_property PACKAGE_PIN L19 [get_ports HDMI_CLK_P]
set_property PACKAGE_PIN K21 [get_ports HDMI_DATA_P[0]]
set_property PACKAGE_PIN J20 [get_ports HDMI_DATA_P[1]]
set_property PACKAGE_PIN G17 [get_ports HDMI_DATA_P[2]]
set_property PACKAGE_PIN H15 [get_ports HDMI_HPD_CON]

set_property IOSTANDARD TMDS_33  [get_ports HDMI_CLK_P]
set_property IOSTANDARD TMDS_33  [get_ports HDMI_DATA_P[0]]
set_property IOSTANDARD TMDS_33  [get_ports HDMI_DATA_P[1]]
set_property IOSTANDARD TMDS_33  [get_ports HDMI_DATA_P[2]]
set_property IOSTANDARD LVCMOS33 [get_ports HDMI_HPD_CON]

# UART
set_property PACKAGE_PIN U2 [get_ports UART_RX]
set_property PACKAGE_PIN V2 [get_ports UART_TX]

set_property IOSTANDARD LVCMOS33 [get_ports UART_RX]
set_property IOSTANDARD LVCMOS33 [get_ports UART_TX]

# EEPROM
set_property PACKAGE_PIN J22 [get_ports EEPROM_I2C_SCL]
set_property PACKAGE_PIN H22 [get_ports EEPROM_I2C_SDA]

set_property IOSTANDARD LVCMOS33 [get_ports EEPROM_I2C_SCL]
set_property IOSTANDARD LVCMOS33 [get_ports EEPROM_I2C_SDA]

# SD CARD
set_property PACKAGE_PIN U7  [get_ports SD_CLK]
set_property PACKAGE_PIN AA8 [get_ports SD_CMD]
set_property PACKAGE_PIN W9  [get_ports SD_DATA[0]]
set_property PACKAGE_PIN Y9  [get_ports SD_DATA[1]]
set_property PACKAGE_PIN Y7  [get_ports SD_DATA[2]]
set_property PACKAGE_PIN Y8  [get_ports SD_DATA[3]]

set_property IOSTANDARD LVCMOS33 [get_ports SD_CLK]
set_property IOSTANDARD LVCMOS33 [get_ports SD_CMD]
set_property IOSTANDARD LVCMOS33 [get_ports SD_DATA[*]]

# QSPI FLASH
set_property PACKAGE_PIN T19 [get_ports QSPI_CS]
set_property PACKAGE_PIN L12 [get_ports QSPI_CLK]
set_property PACKAGE_PIN P22 [get_ports QSPI_DQ[0]]
set_property PACKAGE_PIN R22 [get_ports QSPI_DQ[1]]
set_property PACKAGE_PIN P21 [get_ports QSPI_DQ[2]]
set_property PACKAGE_PIN R21 [get_ports QSPI_DQ[3]]

set_property IOSTANDARD LVCMOS33 [get_ports QSPI_CS]
set_property IOSTANDARD LVCMOS33 [get_ports QSPI_CLK]
set_property IOSTANDARD LVCMOS33 [get_ports QSPI_DQ[*]]

# ETHERNET
set_property PACKAGE_PIN N22 [get_ports ETH_nRST]
set_property PACKAGE_PIN M22 [get_ports ETH_MDC]
set_property PACKAGE_PIN M20 [get_ports ETH_MDIO]
set_property PACKAGE_PIN K18 [get_ports ETH_RXCK]
set_property PACKAGE_PIN K19 [get_ports ETH_RXCTL]
set_property PACKAGE_PIN L14 [get_ports {ETH_RXD[0]}]
set_property PACKAGE_PIN M15 [get_ports {ETH_RXD[1]}]
set_property PACKAGE_PIN L16 [get_ports {ETH_RXD[2]}]
set_property PACKAGE_PIN M16 [get_ports {ETH_RXD[3]}]
set_property PACKAGE_PIN K17 [get_ports ETH_TXCK]
set_property PACKAGE_PIN N20 [get_ports ETH_TXCTL]
set_property PACKAGE_PIN K16 [get_ports {ETH_TXD[0]}]
set_property PACKAGE_PIN L15 [get_ports {ETH_TXD[1]}]
set_property PACKAGE_PIN L13 [get_ports {ETH_TXD[2]}]
set_property PACKAGE_PIN M13 [get_ports {ETH_TXD[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports ETH_nRST]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_MDC]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_MDIO]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_RXCK]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_RXCTL]
set_property IOSTANDARD LVCMOS33 [get_ports {ETH_RXD[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_TXCK]
set_property IOSTANDARD LVCMOS33 [get_ports ETH_TXCTL]
set_property IOSTANDARD LVCMOS33 [get_ports {ETH_TXD[*]}]

