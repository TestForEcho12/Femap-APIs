import simpy
import numpy as np

# Input variables
run_time = 5000
arrival_rate = 0.2
checkers = 4
check_time = 0.75
scanners = 4
scan_time_l = 0.5
scan_time_u = 1

# Create a blank list to collect stats
passengers = []


# Create airport object
class Airport(object):

    # Initalize class attributes
    def __init__(self, env, checkers, check_time, scanners, scan_time_l, scan_time_u):
        self.env = env
        self.checkers = simpy.Resource(env, checkers)
        self.check_time = check_time
        self.scanners = simpy.Resource(env, scanners)
        self.stl = scan_time_l
        self.stu = scan_time_u

    # Create "Checkers" and "Scanners"
    def check_in(self, passenger):
        yield self.env.timeout(np.random.exponential(self.check_time))
        
    def scan(self, passenger):
        yield self.env.timeout(np.random.uniform(self.stl, self.stu))


# Passenger function and how they flow through the airport
def passenger(env, passenger, airport):
    arrive = env.now
    # Request a "Checker" and log times
    with airport.checkers.request() as request:
        yield request
        check_start = env.now
        yield env.process(airport.check_in(passenger))
        check_complete = env.now
    # Request a "Scanner" and log times
    with airport.scanners.request() as request:
        yield request
        scan_start = env.now
        yield env.process(airport.scan(passenger))
        scan_complete = env.now

    # Store all of stats in the "passengers" list as a dictionary 
    passengers.append({'id'         : passenger,
                       'check wait' : check_start - arrive,
                       'check time' : check_complete - check_start,
                       'scan wait'  : scan_start - check_complete,
                       'scan time'  : scan_complete - scan_start,
                       'total'      : scan_complete - arrive,})


# Build the setup function
def setup(env, arrival_rate, checkers, check_time, scanners, scan_time_u, scan_time_l):
    # Create the airport
    airport = Airport(env, checkers, check_time, scanners, scan_time_u, scan_time_l)

    # Passengers arrive at the airport
    i = 0
    while True:
        yield env.timeout(np.random.exponential(arrival_rate))
        i += 1
        env.process(passenger(env, i, airport))


# Run the simulation
env = simpy.Environment()
env.process(setup(env, arrival_rate, checkers, check_time, scanners, scan_time_u, scan_time_l))
env.run(until=run_time)

# Loop through the stats to find average wait times
check_wait = 0
check_time = 0
scan_wait = 0
scan_time = 0
total = 0
num_passengers = len(passengers)
for p in passengers:
    check_wait += p['check wait']
    check_time += p['check time']
    scan_wait += p['scan wait']
    scan_time += p['scan time']
    total += p['total']
    
check_wait = check_wait/num_passengers
check_time = check_time/num_passengers
scan_wait = scan_wait/num_passengers
scan_time = scan_time/num_passengers
total = total/num_passengers
    

print(f'\nThe average check in wait was {check_wait:.2f}')
print(f'The average check in time was {check_time:.2f}')
print(f'The average scan wait was {scan_wait:.2f}')
print(f'The average scan time was {scan_time:.2f}')
print(f'The average total time was {total:.2f}')
    