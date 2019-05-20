# Shots
A Universal iOS App (supports both iPhone and iPad devices) that uses the PicSum
Image APIS to showcase images from this service.
The app has the following two screens:
1. A screen that shows all the images as thumbnails arranged in a collection view.
2. Tapping on a thumbnail in the collection view opens a screen that shows the
image on the full screen. The following informations are overlaid on the image in its
bottom part.
a. ID
b. Author
c. Width in points
d. Height in points

- The UI is adapted to both iPhone and iPad devices.
- The collection view keeps loading more content
as the user keep scrolling down.
- Modern MVVM patern

#TODOS:
1) Add unit test cases.
2) Stop calling List api when all contents are fetched.
3) Inside detai page, if swipes down, load the next image with its details with charming animation 
4) Add launch animation
5) If user is offline, show alert 

#API Ref:
1. PicSum API details: https://picsum.photos/
2. PicSum List API: https://picsum.photos/v2/list?page=2&limit=100
3. PicSum Image Detail API: https://picsum.photos/id/237/200/300

