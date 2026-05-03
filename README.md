# TRIMP Calculator

A simple Ruby implementation of a **TRIMP (Training Impulse)** calculator for quantifying training load and intensity.

## What is TRIMP?

TRIMP is a metric used in sports science to measure the physiological stress and training load during an exercise session. It combines:
- **Duration** of the workout
- **Intensity** (based on heart rate relative to max and resting heart rate)
- **Gender factor** (accounts for physiological differences)

## TRIMP Methods

This calculator supports three different TRIMP calculation methods, each with different approaches to quantifying training load:

### 1. Linear TRIMP (Standard Formula)

The simplest and most commonly used method.

**Formula:**
```
TRIMP = Duration (minutes) × Intensity Factor × Gender Factor

Where:
- Intensity Factor = (Average HR - Resting HR) / (Max HR - Resting HR)
- Gender Factor = 1.0 for males, 0.86 for females
```

**Characteristics:**
- Linear relationship between intensity and TRIMP score
- Treats all intensity levels equally
- Best for steady-state or moderate-intensity training
- Easier to interpret and communicate

**When to use:** General training monitoring, simplicity, and comparing workouts with varying intensities.

### 2. bTRIMP (Bannister's TRIMP)

An exponential model that emphasizes high-intensity efforts.

**Formula:**
```
bTRIMP = Duration (minutes) × Intensity Factor × e^(k × Intensity Factor)

Where:
- Intensity Factor = (Average HR - Resting HR) / (Max HR - Resting HR)
- k = 1.92 for males, 1.67 for females (exponential coefficient)
- e = mathematical constant (≈2.718)
```

**Characteristics:**
- Exponential weighting gives more credit to higher intensity efforts
- High-intensity intervals accumulate more training stress
- Typical bTRIMP values are 1.5-2× higher than linear TRIMP
- Better reflects the non-linear physiological response to intensity
- More sensitive to intensity changes

**When to use:** High-intensity training, interval workouts, competitive athletes, when emphasizing intensity over duration.

### 3. eTRIMP (Edwards' TRIMP)

A zone-based method that categorizes training into 5 heart rate zones.

**Formula:**
```
eTRIMP = Σ(Minutes in Zone × Zone Multiplier)

Zone definitions (based on % of max HR):
- Zone 1 (50-60% of max HR):  multiplier = 1
- Zone 2 (60-70% of max HR):  multiplier = 2
- Zone 3 (70-80% of max HR):  multiplier = 3
- Zone 4 (80-90% of max HR):  multiplier = 4
- Zone 5 (90-100% of max HR): multiplier = 5
```

**Characteristics:**
- Zone-based approach reflects different physiological systems
- Each zone targets different energy systems and adaptations
- Accounts for varied intensity during mixed workouts
- Multipliers increase exponentially by zone
- Can be calculated for single-zone or mixed-zone workouts

**When to use:** Multi-zone training sessions, detailed workout analysis, tracking time in specific zones, understanding zone distribution.

---

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

### Linear TRIMP (Standard Method)

| Weekly Score | Interpretation |
|---|---|
| < 150 | Very light training week |
| 150-300 | Light training week |
| 300-500 | Moderate training week |
| 500-750 | Hard training week |
| 750-1000 | Very hard training week |
| > 1000 | Extreme training week (recovery needed) |

**Training Phase Guidelines:**
- **Base phase**: 300-500 (steady, consistent training)
- **Build phase**: 500-750 (increased intensity and volume)
- **Peak phase**: 750-1000+ (high intensity)
- **Recovery phase**: < 300 (deliberate rest weeks)

**Sport-Specific Ranges:**
- **Endurance athletes** (cycling, running): 800-1500+/week
- **Team sports**: 300-600/week
- **General fitness**: 200-400/week

### bTRIMP (Bannister's Method)

| Weekly Score | Interpretation |
|---|---|
| < 250 | Very light training week |
| 250-500 | Light training week |
| 500-900 | Moderate training week |
| 900-1500 | Hard training week |
| 1500-2000 | Very hard training week |
| > 2000 | Extreme training week (recovery needed) |

**Training Phase Guidelines:**
- **Base phase**: 500-900 (steady, consistent training)
- **Build phase**: 900-1500 (increased intensity and volume)
- **Peak phase**: 1500-2000+ (high intensity)
- **Recovery phase**: < 500 (deliberate rest weeks)

**Note:** bTRIMP values are typically 1.5-2× higher than linear TRIMP due to exponential weighting of intensity. Use these ranges when tracking high-intensity training and interval workouts.

### eTRIMP (Edwards' Zone-Based Method)

| Weekly Score | Interpretation |
|---|---|
| < 50 | Very light training week |
| 50-150 | Light training week |
| 150-300 | Moderate training week |
| 300-450 | Hard training week |
| 450-600 | Very hard training week |
| > 600 | Extreme training week (recovery needed) |

**Training Phase Guidelines:**
- **Base phase**: 150-300 (mostly Z1-Z2, steady-state)
- **Build phase**: 300-450 (mix of Z2-Z3, some Z4 work)
- **Peak phase**: 450-600+ (emphasis on Z4-Z5, high intensity)
- **Recovery phase**: < 100 (mostly Z1, deliberate easy weeks)

**Zone Distribution Tips:**
- **Recovery weeks**: 80% Z1, 20% Z2
- **Base weeks**: 60% Z2, 30% Z3, 10% higher zones
- **Build weeks**: 40% Z2, 35% Z3, 15% Z4, 10% Z5
- **Peak weeks**: 30% Z3, 30% Z4, 25% Z5, 15% Z1-Z2

### Key Principles (All Methods)

- **Progression**: Gradually increase weekly TRIMP over time
- **Variation**: Alternate hard and easy weeks
- **Sustainability**: Your TRIMP should be maintainable without burnout
- **Individual Response**: Track how you feel at different TRIMP levels
- **Method Consistency**: Pick one or combine methods for comprehensive analysis

### Example Weekly Periodization (All Methods)

**Recovery Week:**
- Linear TRIMP: 250
- bTRIMP: 400
- eTRIMP: 80

**Build Week:**
- Linear TRIMP: 450
- bTRIMP: 750
- eTRIMP: 220

**Hard Week:**
- Linear TRIMP: 600
- bTRIMP: 1100
- eTRIMP: 350

**Peak Week:**
- Linear TRIMP: 800
- bTRIMP: 1600
- eTRIMP: 480

## Usage

### Initialization

```ruby
require './trimp_calculator'

# Create a calculator instance with your workout data
calculator = TRIMPCalculator.new(
  duration_minutes = 60,      # Workout duration in minutes
  avg_heart_rate = 150,        # Average heart rate in bpm
  max_heart_rate = 200,        # Your max heart rate in bpm
  resting_heart_rate = 60,     # Your resting heart rate in bpm
  gender = :male               # :male or :female
)
```

### Calculating Linear TRIMP

```ruby
# Calculate standard linear TRIMP
trimp_score = calculator.calculate
puts "Linear TRIMP: #{trimp_score}"
# Output: Linear TRIMP: 56.25

# Classify the weekly score
classification = TRIMPCalculator.classify_trimp(totales_trimp)
puts classification[:interpretation]  
# Output: Moderate training week
```

### Calculating bTRIMP (Bannister's)

```ruby
# Calculate exponential TRIMP (emphasizes intensity)
btrimp_score = calculator.calculate_btrimp
puts "bTRIMP: #{btrimp_score}"
# Output: bTRIMP: 142.67 (higher than linear due to exponential weighting)

# Classify the weekly bTRIMP score
btrimp_classification = TRIMPCalculator.classify_btrimp(totales_btrimp)
puts btrimp_classification[:interpretation]
```

### Calculating eTRIMP (Edwards' Zone-Based)

```ruby
# Method 1: Simple calculation based on average HR
# (assumes entire workout at average heart rate in a single zone)
etrimp_score = calculator.calculate_etrimp
puts "eTRIMP (single zone): #{etrimp_score}"
# Output: eTRIMP: 180.0 (60 min × zone 3 multiplier)

# Method 2: Detailed calculation for mixed-zone workouts
# Specify minutes spent in each zone
zone_breakdown = {
  z1: 10,  # 10 minutes in zone 1
  z2: 20,  # 20 minutes in zone 2
  z3: 15,  # 15 minutes in zone 3
  z4: 10,  # 10 minutes in zone 4
  z5: 5    # 5 minutes in zone 5
}

etrimp_detailed = calculator.calculate_etrimp_detailed(zone_breakdown)
puts "eTRIMP (mixed zones): #{etrimp_detailed}"
# Output: eTRIMP (mixed zones): 150.0
# Calculation: (10×1) + (20×2) + (15×3) + (10×4) + (5×5) = 150

# Classify the weekly eTRIMP score
etrimp_classification = TRIMPCalculator.classify_etrimp(totales_etrimp)
puts etrimp_classification[:interpretation]
```

### Complete Example with All Methods

```ruby
require './trimp_calculator'

# Workout data
duration = 60          # minutes
avg_hr = 150          # bpm
max_hr = 200          # bpm
resting_hr = 60       # bpm

calculator = TRIMPCalculator.new(duration, avg_hr, max_hr, resting_hr, :male)

# Calculate all three methods
trimp = calculator.calculate
btrimp = calculator.calculate_btrimp
etrimp = calculator.calculate_etrimp

puts "=== Workout Analysis ==="
puts "Duration: #{duration} minutes at #{avg_hr} bpm average"
puts "---"
puts "Linear TRIMP:  #{trimp}"
puts "bTRIMP:        #{btrimp}"
puts "eTRIMP:        #{etrimp}"
```

### Parameters

- `duration_minutes` - Length of the workout in minutes (positive integer)
- `avg_heart_rate` - Average heart rate during the workout in bpm
- `max_heart_rate` - Maximum heart rate in bpm
- `resting_heart_rate` - Resting heart rate in bpm
- `gender` - `:male` or `:female` (default: `:male`)

## Comparing the Three Methods

### When to Use Each Method

| Method | Best For | Characteristics | Typical Range (60-min session) |
|--------|----------|-----------------|--------------------------------|
| **Linear TRIMP** | General training, easy comparison, steady-state workouts | Simple, intuitive, linear scaling | 30-80 points |
| **bTRIMP** | High-intensity training, interval workouts, elite athletes | Exponential scaling, emphasizes intensity | 50-200 points |
| **eTRIMP** | Mixed-zone training, detailed zone analysis, periodization | Zone-based, multi-intensity workouts | 40-300 points |

### Example Comparison

Same 60-minute workout at 150 bpm average HR for a male athlete:
- Max HR: 200 bpm | Resting HR: 60 bpm | Intensity: 60% of max HR

| Method | Score | Intensity Weight | Use Case |
|--------|-------|------------------|----------|
| **Linear TRIMP** | 56.25 | Proportional | Quick assessment |
| **bTRIMP** | 142.67 | Exponential | High-intensity tracking |
| **eTRIMP** | 180.0 | Zone-based (Z3) | Detailed analysis |

**Key Insights:**
- bTRIMP is higher for high-intensity workouts (shows more stress)
- eTRIMP is ideal for tracking zone time and periodization
- Linear TRIMP provides a baseline for comparison
- All three provide valid perspectives on training load

### Guidelines by Training Phase

**Recovery Week:** Focus on low zones
- Linear TRIMP: < 150 weekly
- bTRIMP: < 250 weekly
- eTRIMP: < 50 weekly (mostly Z1-Z2)

**Build Week:** Mix of zones with emphasis on Z2-Z3
- Linear TRIMP: 300-500 weekly
- bTRIMP: 500-900 weekly
- eTRIMP: 150-300 weekly

**Peak Week:** High-intensity emphasis (Z4-Z5)
- Linear TRIMP: 750-1000+ weekly
- bTRIMP: 1500+ weekly
- eTRIMP: 300-600 weekly (high zone distribution)

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
