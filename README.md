# TRIMP & TSS Calculator

A Ruby implementation of **TRIMP (Training Impulse)** and **TSS (Training Stress Score)** calculators for quantifying training load and intensity across multiple sports including running, cycling, and other endurance activities.

## What is TRIMP?

TRIMP is a metric used in sports science to measure the physiological stress and training load during an exercise session. It combines:
- **Duration** of the workout
- **Intensity** (based on heart rate relative to max and resting heart rate)
- **Gender factor** (accounts for physiological differences)

TRIMP works for any sport where you can measure heart rate consistently, including running, cycling, swimming, and other endurance activities.

## What is TSS?

TSS (Training Stress Score) is a heart rate-based adaptation of power-based training stress calculations, originally used in cycling but highly effective for running. It uses:
- **Duration** of the workout
- **Intensity Factor** (average heart rate relative to lactate threshold heart rate)

TSS provides a more granular measure of training intensity and is particularly useful for runners tracking sustained efforts around threshold pace.

---

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

**When to use:** General training monitoring, simplicity, and comparing workouts with varying intensities across all sports.

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

## Running TSS (Training Stress Score)

A heart-rate based training stress metric specifically optimized for running (and other sustained endurance efforts).

**Formula:**
```
TSS = (Duration (minutes) × Intensity Factor²) / 100

Where:
- Intensity Factor = Average HR / Lactate Threshold HR (LTHR)
```

**Characteristics:**
- Uses lactate threshold as the reference point instead of max HR
- Intensity factor is squared, giving exponential weight to harder efforts
- Better reflects the non-linear physiological stress of sustained efforts
- Ideal for tempo runs, threshold work, and interval sessions
- Complementary to TRIMP for runners seeking detailed training load analysis

**Why use TSS for running?**
- More sensitive to running-specific intensity metrics
- Lactate threshold is more stable and less variable than max HR
- Better tracks sustained efforts at race pace
- Easier to correlate with running performance and adaptation
- Works exceptionally well for structured training plans

### Determining Your Lactate Threshold HR (LTHR)

There are three ways to find your LTHR:

1. **Field Test (Most Accurate):** Run hard for 30 minutes at a pace you can sustain. Your average HR is approximately your LTHR.

2. **Heart Rate Reserve Method:** LTHR ≈ 85-90% of your max HR (more reliable than the 220-age formula if you know your actual max)

3. **Testing Labs:** Get a professional lactate test for the most accurate measurement

### When to Use TRIMP vs TSS for Running

| Method | Best For | Input Metrics |
|--------|----------|---------------|
| **TRIMP** | General running tracking, comparing different sports | Max HR, Resting HR, Average HR |
| **TSS** | Detailed running analysis, threshold-focused training | Lactate Threshold HR, Average HR |

Both methods work well for running. Use TRIMP if you already track resting and max HR. Use TSS if you want more precise threshold-based metrics.

---

## Gender Factor

The **Gender factor** is a multiplier (TRIMP only) that accounts for physiological differences between males and females in how they respond to training stress:

- **Male: 1.0** (no adjustment)
- **Female: 0.86** (approximately 14% reduction)

The 0.86 factor for females reflects research showing that women typically have different hormonal responses to training, different lactate accumulation patterns, and different cardiovascular adaptations.

### Example

For the same 60-minute workout at 150 bpm average HR:
- **Male**: TRIMP = 60 × intensity factor × 1.0
- **Female**: TRIMP = 60 × intensity factor × 0.86

---

## Weekly Guidelines

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
- **Endurance athletes** (running, cycling): 800-1500+/week
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

### Running TSS (Training Stress Score - Weekly)

| Weekly Score | Interpretation | Training Phase | Recommendation |
|---|---|---|---|
| < 100 | Very light training week | Recovery phase | Mostly easy runs, focus on recovery |
| 100-250 | Light training week | Recovery/Base phase | Easy runs with one moderate session |
| 250-400 | Moderate training week | Base building phase | Mix of easy runs and 1-2 moderate sessions |
| 400-550 | Hard training week | Build phase | Mix of easy, moderate, and one hard session |
| 550-700 | Very hard training week | Peak training phase | High volume with 2-3 intense sessions |
| > 700 | Extreme training week | Peak/Race week or overtraining risk | Consider recovery week next. Monitor fatigue closely. |

### Key Principles (All Methods)

- **Progression**: Gradually increase weekly score over time
- **Variation**: Alternate hard and easy weeks
- **Sustainability**: Your score should be maintainable without burnout
- **Individual Response**: Track how you feel at different score levels
- **Method Consistency**: Pick one or combine methods for comprehensive analysis

---

## Usage

### TRIMP Calculator

#### Initialization

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

#### Calculating Linear TRIMP

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

#### Calculating bTRIMP (Bannister's)

```ruby
# Calculate exponential TRIMP (emphasizes intensity)
btrimp_score = calculator.calculate_btrimp
puts "bTRIMP: #{btrimp_score}"
# Output: bTRIMP: 142.67 (higher than linear due to exponential weighting)

# Classify the weekly bTRIMP score
btrimp_classification = TRIMPCalculator.classify_btrimp(totales_btrimp)
puts btrimp_classification[:interpretation]
```

#### Calculating eTRIMP (Edwards' Zone-Based)

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

#### Complete Example with All TRIMP Methods

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

### Running TSS Calculator

#### Initialization

```ruby
require './running_tss_calculator'

# Create a calculator instance for a running workout
calculator = RunningTSSCalculator.new(
  duration_minutes = 40,           # Workout duration in minutes
  avg_heart_rate = 155,             # Average heart rate in bpm
  lactate_threshold_hr = 160,       # Your LTHR in bpm
  gender = :male                    # :male or :female (optional)
)
```

#### Calculating TSS for a Single Run

```ruby
# Calculate TSS for the workout
tss_score = calculator.calculate_tss
puts "TSS: #{tss_score}"
# Output: TSS: 59.77

# Get intensity factor
intensity_factor = calculator.intensity_factor
puts "Intensity Factor: #{intensity_factor}"
# Output: Intensity Factor: 0.969

# Get zone information
zone_info = calculator.get_hr_zone_info
puts "Zone: #{zone_info[:name]} (#{zone_info[:hr_percent_of_lthr]}% of LTHR)"
# Output: Zone: Aerobic (Moderate) (96.9% of LTHR)

# Classify the workout
classification = RunningTSSCalculator.classify_tss_workout(tss_score)
puts "Classification: #{classification[:interpretation]}"
# Output: Classification: Moderate workout
```

#### Complete Workout Analysis

```ruby
# Get complete analysis in one call
analysis = calculator.get_workout_analysis

puts "=== Running Workout Analysis ==="
puts "Duration: #{analysis[:duration]} minutes"
puts "Average HR: #{analysis[:avg_hr]} bpm"
puts "LTHR: #{analysis[:lthr]} bpm"
puts "Intensity Factor: #{analysis[:intensity_factor]}"
puts "TSS: #{analysis[:tss]}"
puts "Zone: #{analysis[:zone_info][:name]}"
puts "Classification: #{analysis[:classification][:interpretation]}"
```

#### Weekly TSS Summary

```ruby
require './running_tss_calculator'

# Track multiple runs for the week
workouts = [
  { name: "Monday Easy Run", duration: 30, avg_hr: 130 },
  { name: "Tuesday Tempo", duration: 40, avg_hr: 155 },
  { name: "Wednesday Recovery", duration: 35, avg_hr: 125 },
  { name: "Thursday Long Run", duration: 90, avg_hr: 140 },
  { name: "Friday Easy", duration: 30, avg_hr: 128 },
  { name: "Saturday Hard", duration: 50, avg_hr: 170 }
]

lthr = 160
weekly_tss = 0

workouts.each do |workout|
  calc = RunningTSSCalculator.new(workout[:duration], workout[:avg_hr], lthr, :male)
  tss = calc.calculate_tss
  weekly_tss += tss
  puts "#{workout[:name]}: TSS = #{tss}"
end

puts "---"
puts "Weekly Total TSS: #{weekly_tss.round(2)}"

# Classify the weekly load
weekly_classification = RunningTSSCalculator.classify_tss_weekly(weekly_tss)
puts "Classification: #{weekly_classification[:interpretation]}"
puts "Training Phase: #{weekly_classification[:training_phase]}"
puts "Recommendation: #{weekly_classification[:recommendation]}"
```

### TRIMP Parameters

- `duration_minutes` - Length of the workout in minutes (positive integer)
- `avg_heart_rate` - Average heart rate during the workout in bpm
- `max_heart_rate` - Maximum heart rate in bpm
- `resting_heart_rate` - Resting heart rate in bpm
- `gender` - `:male` or `:female` (default: `:male`)

### Running TSS Parameters

- `duration_minutes` - Length of the workout in minutes (positive integer)
- `avg_heart_rate` - Average heart rate during the workout in bpm
- `lactate_threshold_hr` - Your lactate threshold heart rate in bpm
- `gender` - `:male` or `:female` (default: `:male`, optional)

---

## Comparing TRIMP vs Running TSS

| Aspect | TRIMP | Running TSS |
|--------|-------|------------|
| **Reference Point** | Max HR and Resting HR | Lactate Threshold HR |
| **Calculation** | Linear or exponential | Quadratic (squared intensity) |
| **Best For** | General training load across sports | Running-specific threshold training |
| **Intensity Zones** | Full HR spectrum (0-100% max) | Threshold-focused (primarily 85-115% LTHR) |
| **Typical Range (60 min)** | 30-80 points | 20-200 points depending on effort |
| **Input Complexity** | Medium (need max and resting HR) | Lower (just need LTHR) |

---

## Example Workouts Comparison

### Same 60-minute run at 150 bpm for male athlete:
- Max HR: 200 bpm | Resting HR: 60 bpm | LTHR: 160 bpm

| Method | Score | Interpretation |
|--------|-------|-----------------|
| **Linear TRIMP** | 56.25 | Moderate training |
| **bTRIMP** | 142.67 | Moderate training |
| **eTRIMP** | 180 | Moderate training |
| **Running TSS** | 56.25 | Moderate workout |

---

## Running Examples

```bash
# TRIMP calculator for general sports training
ruby trimp_calculator.rb

# Running TSS calculator for running-specific training load
ruby running_tss_calculator.rb
```

---

## Installation

Simply copy the calculator files to your project and require them:

```ruby
require './trimp_calculator'
require './running_tss_calculator'
```

Or use individually:

```ruby
require './trimp_calculator'        # For TRIMP calculations
require './running_tss_calculator'  # For TSS calculations
```

---

## License

MIT
