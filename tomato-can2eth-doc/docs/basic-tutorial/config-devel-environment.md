---
sidebar_position: 1
---

# STM32F107VCT6 开发环境配置详细操作手册

## 一、文档说明

本文档针对 STM32F107VCT6 开发板，详细讲解基于 STM32CubeIDE 1.18.1 和 STM32CubeMX 6.14.1 的开发环境搭建步骤，包含工具安装、开发板硬件连接、调试器配置等核心内容，确保开发环境可稳定运行并支持 ETH/CAN/串口调试功能。

## 二、软硬件环境准备
### 2.1 软件工具清单
| 工具名称          | 版本号    | 下载地址（官方）                          | 用途说明                     |
|-------------------|-----------|-------------------------------------------|------------------------------|
| STM32CubeMX       | 6.14.1    | https://www.st.com/en/development-tools/stm32cubemx.html | 外设配置、工程代码生成       |
| STM32CubeIDE      | 1.18.1    | https://www.st.com/en/development-tools/stm32cubeide.html | 代码编辑、编译、调试         |
| ST-Link/V2 驱动   | 最新版    | https://www.st.com/en/development-tools/stsw-link009.html | ARM 仿真器（JTAG）驱动       |
| 串口调试助手      | 任意版本  | 第三方工具（如串口助手、SecureCRT）| 查看 UART 调试日志           |

### 2.2 硬件清单
- STM32F107VCT6 开发板 ×1
- ARM 仿真器（支持 JTAG 协议）×1
- 以太网网线 ×1（连接 RJ45 接口与路由器/电脑）
- USB 转串口模块 ×1（若开发板无内置串口）
- DC 电源适配器（5V/12V，匹配开发板 DC 接口）×1
- CAN 模块（如 TJA1050 模块）×1（可选，用于 CAN 功能测试）
- 杜邦线若干（用于外设连接）

## 三、STM32 工具安装配置
### 3.1 STM32CubeMX 安装
1. **下载安装包**：
   - 从官方地址下载对应系统（Windows/Linux）的 STM32CubeMX 6.14.1 安装包；
   - 双击安装包，按向导完成安装，建议安装路径选择非中文目录（如 `D:\ST\STM32CubeMX`）。
2. **安装固件库**：
   - 打开 STM32CubeMX，点击主界面 `Help` -> `Manage embedded software packages`；
   - 在弹出窗口中，展开 `STM32F1 Series`，勾选 `STM32Cube FW_F1 V1.8.5`（或最新兼容版本）；
   - 点击 `Install Now`，等待固件库下载并安装完成。
3. **验证安装**：
   - 重启 STM32CubeMX，在 `New Project` 中可选择 `STM32F107VCT6` 芯片，说明安装成功。

### 3.2 STM32CubeIDE 安装
1. **下载与安装**：
   - 下载 STM32CubeIDE 1.18.1 安装包（含 JRE 运行环境）；
   - 运行安装程序，接受许可协议，选择安装路径（如 `D:\ST\STM32CubeIDE_1.18.1`）；
   - 安装完成后，启动 STM32CubeIDE，首次启动会提示选择工作空间（建议非中文路径）。
2. **配置编译器**：
   - 打开 STM32CubeIDE，点击 `Window` -> `Preferences`；
   - 展开 `STM32Cube` -> `Toolchains`，确认 GCC 编译器路径正确（默认已配置）；
   - 点击 `Apply and Close` 保存配置。

### 3.3 ARM 仿真器驱动安装
1. 将 ARM 仿真器通过 USB 连接到电脑；
2. 电脑自动识别硬件，若未自动安装驱动，手动安装 ST-Link/V2 驱动；
3. 验证驱动：右键 `此电脑` -> `管理` -> `设备管理器`，查看 `端口` 或 `调试器` 列表中是否有 ARM 仿真器设备（无黄色感叹号即正常）。

## 四、开发板硬件连接

![开发板连接](img/004.jpg)

### 4.1 核心连接步骤
1. **供电连接**：
   - 将 DC 电源适配器输出端插入开发板 DC 接口；
   - 确认电源电压匹配（如 5V/12V），打开开发板电源开关，电源指示灯亮起即供电正常。
2. **调试器连接（JTAG）**：
   - 将 ARM 仿真器的 JTAG 接口与开发板 JTAG 接口对齐（注意引脚定义，通常有防呆设计）；
   - 仿真器另一端通过 USB 连接到电脑，完成调试链路搭建。
3. **以太网连接**：
   - 将网线一端插入开发板 RJ45 接口，另一端连接路由器 LAN 口或电脑网口；
   - 连接后，RJ45 接口的 LINK 指示灯亮起（常亮），数据指示灯（闪烁）表示链路正常。
4. **串口调试连接**：
   - 若开发板有内置 USB 转串口：直接用 USB 线连接开发板 USB 串口与电脑；
   - 若为外置串口：用杜邦线连接 USB 转串口模块与开发板 UART 接口（TX-RX、RX-TX、GND-GND）；
   - 串口工具配置：波特率 115200、数据位 8、停止位 1、校验位 None、无流控。
5. **CAN 模块连接（可选）**：
   - 将 CAN 模块的 CAN_H/CAN_L 引脚与开发板 CAN 接口对应连接；
   - CAN 模块供电（3.3V/5V，匹配开发板电平），并接 120Ω 终端电阻（仅两端节点需要）。

### 4.2 连接验证
| 硬件模块       | 验证方式                                  | 正常状态                          |
|----------------|-------------------------------------------|-----------------------------------|
| 供电           | 查看电源指示灯                            | 常亮                              |
| JTAG 调试器    | 设备管理器查看仿真器设备                  | 无黄色感叹号，识别为 ARM 调试器   |
| 以太网         | 查看 RJ45 指示灯                          | LINK 灯常亮，DATA 灯按需闪烁      |
| 串口           | 串口工具打开对应端口，发送 AT 指令（若支持） | 能接收开发板回复或日志输出        |
| CAN 模块       | 用 CAN 调试工具发送数据                   | 开发板可接收 CAN 数据             |

## 五、开发板工程配置与调试
### 5.1 基于 STM32CubeMX 生成工程
1. 打开 STM32CubeMX，点击 `New Project`，搜索 `STM32F107VCT6` 并选择对应芯片；
2. 按前文《STM32F107VCT6 ETH/CAN/LWIP 配置手册》完成引脚、ETH、CAN、LWIP、串口配置；
3. 点击 `Project Manager`，配置：
   - `Project Name`：自定义（如 STM32F107_ETH_CAN）；
   - `Toolchain/IDE`：选择 `STM32CubeIDE`；
   - `Project Location`：非中文路径；
4. 点击 `GENERATE CODE`，生成 STM32CubeIDE 兼容工程。

### 5.2 STM32CubeIDE 导入工程并调试
1. 打开 STM32CubeIDE，点击 `File` -> `Import`；
2. 选择 `General` -> `Existing Projects into Workspace`，点击 `Next`；
3. 选择 STM32CubeMX 生成的工程文件夹，勾选工程名，点击 `Finish`；
4. **调试配置**：
   - 右键工程 -> `Debug As` -> `Debug Configurations`；
   - 选择 `STM32 Cortex-M C/C++ Application`，点击 `New Launch Configuration`；
   - `Debugger` 标签页：选择 `ST-Link (OpenOCD)`，确认 JTAG 接口正常；
   - 点击 `Debug` 进入调试模式。
5. **日志输出验证**：
   - 打开串口调试助手，选择对应串口；
   - 运行程序，串口终端应输出 ETH/CAN/LWIP 初始化日志（如 IP 地址、CAN 波特率等）。

## 六、常见问题排查
### 6.1 调试器连接失败
- 检查 JTAG 引脚接线是否正确（VCC、GND、TCK、TMS、TDI、TDO）；
- 确认开发板供电正常，仿真器驱动已正确安装；
- 在 STM32CubeIDE 中重新配置调试器，选择正确的 JTAG 频率（如 1MHz 低速尝试）。

### 6.2 串口无日志输出
- 核对 UART 引脚配置（TX/RX 交叉连接）；
- 检查串口工具波特率、数据位等参数是否与代码配置一致；
- 确认代码中已实现 `printf` 重定向（参考前文串口配置章节）。

### 6.3 以太网无法联网
- 检查网线是否连通，路由器 DHCP 是否开启（若用动态 IP）；
- 确认 ETH 外设配置为 RMII 模式，HSE 时钟已正确配置；
- 在代码中添加以太网链路状态检测，打印链路是否连接。

### 6.4 CAN 通信异常
- 测量 CAN_H/CAN_L 总线电压（正常为 CAN_H≈3.5V，CAN_L≈1.5V）；
- 检查 CAN 波特率计算是否正确（APB1 时钟最大 36MHz）；
- 确认 CAN 模块终端电阻（120Ω）已正确焊接。

### 总结
1. 开发环境配置核心：确保 STM32CubeMX/IDE 版本匹配，固件库与芯片型号兼容；
2. 硬件连接关键：JTAG 引脚对齐、串口 TX/RX 交叉连接、以太网链路正常；
3. 调试排查重点：驱动安装、供电稳定性、外设参数（波特率/IP 地址）配置正确性。