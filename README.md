# QueueBANSim: GI/G/1 Queue Simulator with Bounded Algorithmic Numbers (BANs)

## Overview
QueueBANSim is a MATLAB-based simulator for GI/G/1 queuing systems incorporating Bounded Algorithmic Numbers (BANs), in accordance with Alpha Theory (see https://doi.org/10.1016/S0723-0869(03)80038-5 for further mathematical details). The software allows the simulation of GI/G/1 queuing processes based on five different scheduling policies, which can be chosen according to the specific use case (see below). The simulator enables numerical evaluation of performance in terms of average delay, even in the case of infinite service/arrival moments.

## Table of Contents
- [Features](#features)
- [Usage](#usage)
- [Installation](#installation)
- [Customizing BAN Parameters](#customazing-ban-parameters)
- [Contributing](#contributing)
- [License](#license)

## Features
- **Bounded Algorithmic Numbers (BANs):** The simulator allows setting the interarrival and service time distributions parameters using BANs to simulate heavy-tailed traffic with infinite (non-diverging) moments (well-defined within the Alpha Theory).
- **Customizable Queue Policies:** Users can choose from five distinct queuing policies for simulation:
  1. **FIFO (First In, First Out)** - File: `nomefile1.m`
  2. **LIFO (Last In, First Out)** - File: `nomefile2.m`
  3. **SIRO (Service In Random Order)** - File: `nomefile3.m`
  4. **SJF (Shortest Job First)** - File: `nomefile4.m`
  5. **SRPT (Shortest Remaining Processing Time)** - File: `nomefile5.m`
- **Delay performance evaluation:** The simulator provides the following outputs:
  1. Average queueing delay,
  2. Corresponding theoretical bounds and approximations,
  3. Average number of customers in the system.


## Usage
1. Clone this repository:
    ```bash
    git clone https://github.com/francesco-fiorini/QueueBANSim.git
    ```
2. Open MATLAB and navigate to the repository folder.

3. Open the "SimulatorScript" file.

4. Customize the distribution parameters for interarrival and service times as Bounded Algorithmic Numbers to simulate heavy-tailed traffic.

5. Select the proper "gg1simulator" method corresponding to the desired queuing policy:
   - For FIFO: `nomefile1.m`
   - For LIFO: `nomefile2.m`
   - For SIRO: `nomefile3.m`
   - For SJF: `nomefile4.m`
   - For SRPT: `nomefile5.m`

6. Run the main script.

## Installation
Make sure MATLAB is installed on your system. To run the simulation, you must have installed BAN and BANARRAY classes in the current repository. Feel free to contact francesco.fiorini@phd.unipi.it for further details on the latter aspect.

## Customizing BAN Parameters
The general interarrival and service time distributions can be customized using Bounded Algorithmic Numbers (BANs) to reflect heavy-tailed characteristics with infinite variance. Ensure you configure these parameters in the script according to your traffic model needs.

## Contributing
Contributions are welcome! Please contact francesco.fiorini@phd.unipi.it for suggested changes.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
