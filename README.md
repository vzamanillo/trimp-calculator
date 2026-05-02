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

## Gender Factor

The **Gender factor** is a multiplier that accounts for physiological differences between males and females in how they respond to training stress:

- **Male: 1.0** (no adjustment)
- **Female: 0.86** (approximately 14% reduction)

The 0.86 factor for females reflects research showing that women typically have different hormonal responses to training, different lactate accumulation patterns, and different cardiovascular adaptations compared to men at the same relative intensity.

### Example

For the same 60-minute workout at 150 bpm average HR:
- **Male**: TRIMP = 60 × intensity factor × 1.0
- **Female**: TRIMP = 60 × intensity factor × 0.86

## Weekly TRIMP Guidelines

### General Interpretation

| Weekly TRIMP | Interpretation |
|---|---|
| < 150 | Very light training week |
| 150-300 | Light training week |
| 300-500 | Moderate training week |
| 500-750 | Hard training week |
| 750-1000 | Very hard training week |
| > 1000 | Extreme training week (recovery needed) |

### Training Phase Guidelines

- **Base phase**: 300-500 (steady, consistent training)
- **Build phase**: 500-750 (increased intensity and volume)
- **Peak phase**: 750-1000+ (high intensity)
- **Recovery phase**: < 300 (deliberate rest weeks)

### Sport-Specific Ranges

- **Endurance athletes** (cycling, running): 800-1500+/week
- **Team sports**: 300-600/week
- **General fitness**: 200-400/week

### Key Principles

- **Progression**: Gradually increase weekly TRIMP over time
- **Variation**: Alternate hard and easy weeks
- **Sustainability**: Your TRIMP should be maintainable without burnout
- **Individual Response**: Track how you feel at different TRIMP levels

### Example Weekly Periodization

```
Week 1: 250 TRIMP (recovery)
Week 2: 450 TRIMP (build)
Week 3: 600 TRIMP (hard)
Week 4: 800 TRIMP (peak)
Week 5: 200 TRIMP (recovery week)
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
