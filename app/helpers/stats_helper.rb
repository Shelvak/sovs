module StatsHelper
  def include_stats_js
    content_for(:head_extra) { javascript_include_tag 'graphs' }
  end
end
