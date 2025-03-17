#  README

I tried to do as many tasks as I could, but my time was very limited, so I selected the ones I thought I could finish.

For the cached images, I thought about using (via SPM) a library called Nuke to handle the images, but I found some nice, simple code that worked well and decided to use that.

For the API calls, the idea was to use async/await at the beginning and change it to combine to see the differences, this change (or update) is in the commits.

Initially, my idea was to focus on finishing the main screen, but I couldn't quite understand the API documentation about how breeds and favourites worked together, to me it would make more sense if there was a flag like 'isFavourite' in the breed model, but I didn't see anything like that (maybe I missed something here).

Anyway, I focused on the details view and was able to finish it.

I didn't even try to implement any of the options for persisting data. It's been a long time since I implemented core data. At New Work I was able to maintain them for a while, but during the migration from UIKIT to SwiftUI we decided to remove all of them, mainly because there was no longer any requirement to maintain them. I would have loved to have some time to try to implement SwiftData, but again, with limited time, I had to focus on what I could build the fastest.

About the bonus points:
- I have no experience with TCA, so I didn't spend time trying to understand it, I had to focus on what I knew;
- I tried to handle some errors from the API call, but it could definitely be better;
- I also didn't have time to implement any E2E tests.
