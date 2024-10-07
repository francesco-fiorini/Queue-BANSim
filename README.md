# QueueBANSim: GI/G/1 Queue Simulator with Bounded Algorithmic Numbers (BANs)

## Overview
QueueBANSim is a MATLAB-based simulator for GI/G/1 queuing systems incorporating Bounded Algorithmic Numbers (BANs), in accordance with the Alpha Theory (see https://doi.org/10.1016/S0723-0869(03)80038-5 for further mathematical details). The software allows for the simulation of queuing processes based on five different scheduling policies, which can be chosen to suit your specific use case.

## Features
- **Bounded Algorithmic Numbers (BANs):** The simulator allows setting the interarrival and service time distributions using BANs to simulate heavy-tailed traffic with infinite variance (well-defined within the Alpha Theory).
- **Customizable Queue Policies:** Users can select from five distinct queuing policies for simulation:
  1. **FIFO (First In, First Out)** - File: `nomefile1.m`
  2. **LIFO (Last In, First Out)** - File: `nomefile2.m`
  3. **SIRO (Service In Random Order)** - File: `nomefile3.m`
  4. **SJF (Shortest Job First)** - File: `nomefile4.m`
  5. **SRPT (Shortest Remaining Processing Time)** - File: `nomefile5.m`

## Usage
1. Clone this repository:
    ```bash
    git clone https://github.com/your-username/QueueBANSim.git
    ```
2. Open MATLAB and navigate to the repository folder.

3. Customize the distribution parameters for interarrival and service times as Bounded Algorithmic Numbers to simulate heavy-tailed traffic.

4. Run the simulation script corresponding to the desired queuing policy:
   - For FIFO: `nomefile1.m`
   - For LIFO: `nomefile2.m`
   - For SIRO: `nomefile3.m`
   - For SJF: `nomefile4.m`
   - For SRPT: `nomefile5.m`

## Installation
Make sure MATLAB is installed on your system. Simply clone the repository, and you can immediately run the simulations.

## Customizing BAN Parameters
The general interarrival and service time distributions can be customized using Bounded Algorithmic Numbers (BANs) to reflect heavy-tailed characteristics with infinite variance. Ensure you configure these parameters in the script according to your traffic model needs.

## Contributing
Feel free to contribute by opening issues or submitting pull requests for additional features or optimizations.

## License
This project is licensed under the MIT License.
