# FPGA Smart Parking Management System

![VHDL](https://img.shields.io/badge/Language-VHDL-blue)
![Xilinx](https://img.shields.io/badge/Tool-Xilinx%20ISE%2014.7-red)
![FPGA](https://img.shields.io/badge/Platform-FPGA-success)
![License](https://img.shields.io/badge/License-MIT-green)

A complete **FPGA-based Smart Parking Management System** designed using **VHDL** and developed with **Xilinx ISE Design Suite 14.7**.

The system simulates an intelligent parking garage capable of managing vehicle entry and exit, monitoring parking occupancy using ultrasonic sensors, calculating parking fees for guest vehicles, and displaying the number of available parking spaces on dual seven-segment displays.

---

### Project Overview

Modern parking facilities require efficient monitoring, automatic access control, and accurate occupancy management. This project implements these concepts entirely in hardware using VHDL.

The system supports both **registered users** and **guest vehicles** while continuously monitoring **50 parking spaces** through ultrasonic sensors.

For registered users, entry and exit are automated using ID validation.

Guest vehicles receive a parking ticket upon entry, and the parking fee is calculated automatically when exiting based on the parking duration.

The project demonstrates several important digital design concepts including:

- Modular VHDL Design
- Concurrent Processes
- Sequential Processes
- Record Data Structures
- Arrays of Records
- Sensor Interfacing
- Seven-Segment Display Control
- FPGA System Design

---

### Features

- Vehicle Entry Detection
- Vehicle Exit Detection
- Automatic Gate Control
- Registered User (ID) Authentication
- Guest Ticket Generation
- Parking Fee Calculation
- Parking Duration Tracking
- Parking Occupancy Monitoring
- 50 Parking Spaces
- Ultrasonic Sensor Integration
- Parking Full Detection
- LED Indicators for Every Parking Space
- Dual Seven-Segment Display
- Real-Time Free Space Counter
- Modular VHDL Architecture

---

### System Architecture

```
                    Vehicle Arrives
                           │
                           ▼
                 Is Driver Registered?
                    (Valid ID Check)
                    ┌───────────────┐
               Yes  │               │ No
                    ▼               ▼
              Open Gate      Generate Ticket
                    │               │
                    └──────┬────────┘
                           ▼
                  Enter Parking Area
                           │
                           ▼
               Ultrasonic Sensor Detection
                           │
                           ▼
               Update Parking Occupancy
                           │
            ┌──────────────┴──────────────┐
            ▼                             ▼
      LED Indicators            Seven Segment Display
                           │
                           ▼
                    Vehicle Exit
                           │
            Registered User?      Guest?
                 │                  │
                 ▼                  ▼
            Open Gate       Calculate Parking Fee
                 │                  │
                 └──────────┬───────┘
                            ▼
                       Open Exit Gate
```

---

### System Specifications

| Feature | Description |
|----------|-------------|
| Language | VHDL |
| Development Tool | Xilinx ISE Design Suite 14.7 |
| Parking Capacity | 50 Parking Spaces |
| Maximum Guest Records | 100 |
| Parking Detection | Ultrasonic Sensors |
| Display | Dual Seven-Segment Display |
| Parking Fee | \$2 per Minute |
| Authentication | Valid ID or Parking Ticket |

---

## Main Functionalities

## Registered Users

- Vehicle ID is validated.
- Gate opens automatically.
- No parking ticket is required.
- No parking fee is calculated.
- Fast entry and exit.

---

### Guest Vehicles

- A unique parking ticket is generated.
- Entry time is stored.
- Exit time is recorded.
- Parking duration is calculated.
- Parking fee is automatically computed.

Parking Fee Formula

```
Parking Fee = (Exit Time − Entry Time) × $2
```

---

### Parking Space Monitoring

Each parking space contains an ultrasonic sensor.

The sensors continuously monitor whether a vehicle is occupying the parking space.

The system automatically updates:

- Parking occupancy
- Free parking spaces
- Occupied parking spaces
- LED indicators
- Seven-segment displays

---

### Parking Availability

The parking lot continuously calculates:

- Number of occupied spaces
- Number of available spaces

If all spaces are occupied, the system activates the **Parking Full** indicator.

---

### Internal Design

The design is divided into several logical modules.

| Module | Purpose |
|---------|---------|
| parkingsys.vhd | Main parking controller |
| mandm.vhd | Entry and Exit management |
| mm.vhd | Parking management logic |
| simm.vhd | Sensor simulation |
| testt.vhd | Testbench |

---

### Record-Based Guest Database

The project uses a custom VHDL **Record** to store guest information.

Each guest record contains:

- Ticket Number
- Entry Time
- Exit Time

A dynamic array of records stores up to **100 guest records**, allowing efficient management of guest vehicles without maintaining separate arrays for each field.

---

### Seven-Segment Display

The system drives two common-anode seven-segment displays.

The displays continuously show the number of available parking spaces.

Example:

```
Available Spaces = 12

Left Display  -> 1
Right Display -> 2
```

---

## LED Indicators

Each parking space has its own LED.

| LED State | Parking Space |
|-----------|---------------|
| ON | Free |
| OFF | Occupied |


### How to Run

1. Open **SmartParkingSystem.xise** using **Xilinx ISE Design Suite 14.7**.
2. Build the project.
3. Run behavioral simulation.
4. Observe waveform outputs.
5. Verify parking occupancy, gate control, payment calculation, and seven-segment display functionality.

---

### Screenshots


### Behavioral Simulation

<img width="973" height="638" alt="Screenshot 2025-05-06 012134" src="https://github.com/user-attachments/assets/d181ba04-ee22-4f2e-a3e7-e50dcde2abe7" />

<img width="968" height="576" alt="Screenshot 2025-05-06 014544" src="https://github.com/user-attachments/assets/a0d97bd6-95e8-4258-a6f5-03bb36c0f4b6" />


### Seven-Segment Display Output

<img width="926" height="702" alt="Screenshot 2025-05-05 235050" src="https://github.com/user-attachments/assets/a24b74cc-5927-4222-a1ed-5a4e370fd7e8" />

### Future Improvements

- RFID Authentication
- License Plate Recognition
- LCD Display Interface
- Mobile Application Integration
- Multi-Level Parking Support
- Real FPGA Hardware Deployment
- UART Communication
- IoT-Based Remote Monitoring

---

### Skills Demonstrated

This project demonstrates knowledge of:

- VHDL Programming
- FPGA Design
- Digital Logic Design
- Hardware Description Languages
- Concurrent Programming
- Sequential Logic
- Record Data Structures
- Sensor Interfacing
- Seven-Segment Display Control
- State-Based System Design
- Simulation and Verification
- Modular Hardware Design

---

### Author
Mai Mokbel
Digital Logic Design Project

