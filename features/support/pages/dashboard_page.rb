class DashboardPage
	include PageObject


	in_iframe(index: 0) do |iframe|
		div(:chart_prensent, class: 'showChart', frame: iframe)
	end

end
