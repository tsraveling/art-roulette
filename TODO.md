# TODO

## Image Library / Tagging Update

- **Schema**
	- Image
		- filename
		- folder
		- path
		- description
		- last_curated
	- Tag
	- Image_Tag join table
	- Collection
	- Image_Collection join table
	- Folder

- [ ] Core library systems
	- [ ] Create initial "library setup screen"
		- [ ] I will see an intro screen with intro text
		- [ ] On this screen I will have the opportunity to select a "library core" folder
	- [ ] SQLite implementation
		- [ ] Library initialization happens as an .arlibrary file in the library root.
			- Use [this GPT thread](https://chat.openai.com/share/376049a5-cf54-4306-a583-0cb58ddd7245) for reference
		- [ ] If there is already a .arlibrary file in that location, we will just open that
		- [ ] DB setup with image and tag schemas, and eventual support for other data types
	- [ ] Initial library scan and setup
		- [ ] Do schema creation
		- [ ] Scan recursively through all images and create records for all of them
- [ ] Library maintenance
	- [ ] Every launch, on a separate thread, scan the file structure again.
	- [ ] Archive any images that have been deleted
	- [ ] Add any new ones
	- [ ] At the end, present a summary of the work to the user
- [ ] Workspace screen
	- [ ] UI primarily presents a quick way to start a session
	- [ ] There is also a small side menu with Manage Tags, Curation, and Settings
- [ ] Settings
	- [ ] I will see a version number
	- [ ] I will see a "Change Library Root" option that goes to the initial Library Setup Screen
- [ ] Tag management
	- [ ] Screen will have a sidebar on the left with all tags, and an image count next to each.
	- [ ] When I select a tag, images will appear in a grid on the right side.
	- [ ] The top bar on the right side will have the tag title, and a delete button on the right side.
		- [ ] If I hit the delete button, I will see a confirm dialog, after which the tag and any related joins will be deleted.
	- [ ] Child images will be shown in groups underneath the main image grid area.
	- [ ] The top of the left bar will also have a create tag option, which will extend a box with a text field.
		- [ ] New tags will be created on Enter, but the text field will stay open, allowing me to create tags quickly.
		- [ ] If I hit escape, the tag entry area will disappear.
		- [ ] Entering tags like `anatomy/hands` will automatically create a child tag.
	- [ ] The top tag bar will also have an Add Tag option, which will allow the same quick tag entry system, but as a child of this tag.
- [ ] Session setup
	- [ ] You can enable folder filtering.
	- [ ] If folder filtering is enabled, you can multi-select the folder structure.
	- [ ] You can enable tag filtering.
	- [ ] If tag filtering is enabled, you can multiselect tags.
	- [ ] Multiselection feature:
		- [ ] Selecting a folder selects all children.
		- [ ] Deselecting a folder deselects all children.
		- [ ] Directly selecting a child only selects the child.
- [ ] Image curation
	- [ ] At the start of the curation process, you can pick "uncurated (count)", "refresh (longest since last curated)", or by folder.
	- [ ] You can select order by folder, by date, or by random.
	- [ ] Each image pops up with the curation sidebar -- a list of all tags that you can tap to toggle.
	- [ ] You can add tags using the same UI as in tag management (add button at top).
	- [ ] You can also add a text description, which can be used for searching.
- [ ] Search feature
	- [ ] You can type search terms, which will search by tag, filename, and description.
- [ ] Collection feature
	- [ ] You can create virtual collections, ie for specific projects
	- [ ] There's an "add" system that uses search to quickly find images to add
	- [ ] You can specify a collection home folder (optionally)
	- [ ] If you have that, you can drag images directly into the collection view.

## Someday / Maybe

- [ ] Add an "end of session" report
