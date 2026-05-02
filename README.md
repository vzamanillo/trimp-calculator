# TRIMP Calculator

A simple Ruby implementation of a **TRIMP (Training Impulse)** calculator for quantifying training load and intensity.

## What is TRIMP?

TRIMP is a metric used in sports science to measure the physiological stress and training load during an exercise session. It combines:
- **Duration** of the workout
- **Intensity** (based on heart rate relative to max and resting heart rate)
- **Gender factor** (accounts for physiological differences)

## Formula

```
TRIMP = Duration (minutes) × Intensity Factor × Gender Factor

Intensity Factor = (Average HR - Resting HR) / (Max HR - Resting HR)
Gender Factor = 1.0 for males, 0.86 for females
```

## Usage

### Basic Example

```ruby
require './trimp_calculator'

calculator = TRIMPCalculator.new(
  duration_minutes: 60,
  avg_heart_rate: 150,
  max_heart_rate: 200,
  resting_heart_rate: 60,
  gender: :male
)

trimp_score = calculator.calculate
puts "TRIMP Score: #{trimp_score}"
```

### Parameters

- `duration_minutes` - Length of the workout in minutes (positive integer)
- `avg_heart_rate` - Average heart rate during the workout in bpm
- `max_heart_rate` - Maximum heart rate in bpm
- `resting_heart_rate` - Resting heart rate in bpm
- `gender` - `:male` or `:female` (default: `:male`)

## Running Examples

```bash
ruby trimp_calculator.rb
```

This will run two example calculations showing how to calculate TRIMP for both male and female athletes.

## Installation

Simply copy `trimp_calculator.rb` to your project and require it:

```ruby
require './trimp_calculator'
```

## License

MIT
