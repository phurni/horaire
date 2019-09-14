class Schedules
  attr_reader :days, :periods
  
  def initialize(config)
    @days = config[:days]
    @periods = config[:periods]

    week_date = Time.parse(config[:year_start_day])
    @weeks_start_dates = config[:working_weeks].each_with_object([]) do |working, memo|
      memo << week_date if working.nonzero?
      week_date += 7*24*60*60 # 1.week
    end

    @current_week_index = 0
    @weeks_blocks = []
  end
  
  def move_to(date)
    date -= 7*24*60*60 # 1.week
    @current_week_index = @weeks_start_dates.find_index {|week_date| week_date > date } || 0
    self
  end
  
  def move_to_next_week
    @current_week_index = [@current_week_index+1, @weeks_blocks.size-1].min
    self
  end
  
  def move_to_previous_week
    @current_week_index = [@current_week_index-1, 0].max
    self
  end
  
  def current_blocks
    @weeks_blocks[@current_week_index]
  end
  
  def current_week_date
    @weeks_start_dates[@current_week_index]
  end
  
  def current_week_number
    @current_week_index+1
  end
  
  def add(day_number, start_period_number, end_period_number, caption_tl, caption_bl, caption_br, caption_tr, weeks)
    weeks.each do |week_number|
      week_blocks = week_blocks_for(week_number)
      
      period_range = Range.new(start_period_number-1, end_period_number-1)
      
      week_blocks[day_number-1][period_range] = Array.new(period_range.size, [caption_tl, caption_bl, caption_br, caption_tr])
    end
  end
  
  private
  
  def week_blocks_for(week_number)
    @weeks_blocks[week_number-1] ||= Array.new(@days.size) { Array.new(@periods.size) }
  end
end
