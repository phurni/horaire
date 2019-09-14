require "opal"
require 'opal/jquery'

require "template"
require "views/schedule"

require 'time'
require 'base64'

require 'models/schedules'

def params
  @params ||= `window.location.hash.substr(1)`.split(/[&;]/).each_with_object({}) do |pairs, memo|
    key, value = pairs.split('=', 2)
    memo[key] = value.gsub(/((?:%[0-9a-fA-F]{2})+)/) { $1.delete('%').to_i(16).chr }
  end
end

def fetch_config(params)
  # First way, having config encoded in params
  if params['config']
    yield JSON.parse(Base64.decode64(params['config']))
  elsif params['config_url']
    HTTP.get(params['config_url']) do |response|
      if response.ok?
        yield response.json
      end
    end
  end
end

def decode_schedules(schedules_lines, config)
  schedules = Schedules.new(config)
  schedules_lines.each_line do |line|
    day_number, start_period_number, end_period_number, caption_tl, caption_tr, caption_br, caption_bl, weeks = line.match(/^\s*(\d+)\s+(\d+)-(\d+)\s+"(.*?)"(?:\s+"(.*?)")?(?:\s+"(.*?)")?(?:\s+"(.*?)")?(?:\s+([\d,]+))?/).captures
    schedules.add(day_number.to_i, start_period_number.to_i, end_period_number.to_i, caption_tl, caption_tr, caption_br, caption_bl, weeks ? weeks.split(",").map(&:to_i) : (1..40).to_a)
  end
  schedules
end

def fetch_schedules(params, config)
  # First way, having schedules encoded in params
  if params['schedules']
    yield decode_schedules(Base64.decode64(params['schedules']), config)
  elsif params['schedules_url']
    HTTP.get(params['schedules_url']) do |response|
      if response.ok?
        yield decode_schedules(response.body, config)
      end
    end
  end
end

def show_schedule(schedules)
  Element.find('#schedule').html = Template['views/schedule'].render(schedules)
end

Document.ready? do
  goto_date = params['goto'] ? Time.parse(params['goto']) : Time.now
  
  fetch_config(params) do |config|
    fetch_schedules(params, config) do |schedules|
      Element.find('#previous').on(:click) do
        show_schedule(schedules.move_to_previous_week)
      end

      Element.find('#next').on(:click) do
        show_schedule(schedules.move_to_next_week)
      end

      show_schedule(schedules.move_to(goto_date))
    end
  end
  
end
