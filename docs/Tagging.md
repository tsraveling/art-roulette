# Tagging

## Desired User Stories

- I can define schema with which to categorize my images:
	- Type: each image can be set to one of a list of categories.
		- Eventually this will be hierarchical
	- Tag: any image can be a member of any tag in a given list.
		- Tags can be type-specific or global.
- Classification admin screen, where you can add tags and types
	- Updates a hidden "version" int which can then be used to re-classify images later.
- Image processing system.
	- System will serve up unprocessed images one at a time.
	- Semi-transparent overlay gives you the options. Buttons light up when you turn them on.
	- Hold shift to hide the overlay
	- Hit space or next button to go to the next image
	- Hit backspace to go to the previous image
- Admin system
	- Thumbnail grid where you can go folder by folder and edit tags, metadata etc