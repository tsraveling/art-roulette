extends Node

const HALF_MIN = 0
const ONE_MIN = 1
const TWO_MIN = 2
const FIVE_MIN = 3
const TEN_MIN = 4
const FIFTEEN_MIN = 5
const TWENTY_MIN = 6
const THIRTY_MIN = 7
const ONE_HOUR = 8
const UNLIMITED = 9

var selected_duration: int

func time_in_seconds(amt: int) -> float:
	match amt:
		HALF_MIN:
			return 30
		ONE_MIN:
			return 60
		TWO_MIN:
			return 120
		FIVE_MIN:
			return 300
		TEN_MIN:
			return 600
		FIFTEEN_MIN:
			return 900
		TWENTY_MIN:
			return 1200
		THIRTY_MIN:
			return 1800
		ONE_HOUR:
			return 3600
		UNLIMITED:
			return -1  # Will disable timer
		_:
			return -1  # Unlimited if anything is unhandled

