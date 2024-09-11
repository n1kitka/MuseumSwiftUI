# Mobile companion app for museum visits

### Вітаю!

##### The purpose of this qualification work is to develop a mobile application for iOS that will serve as a companion for museum visitors. In the work, a recommender system was created, which consists of selecting the relevant part of the catalogue of exhibits for the user based on his interests. The TF-IDF statistic, cosine similarity, and root mean square error together form the basis of a recommender system that helps users select museums, collections, and exhibits that best match their cultural and educational interests.

##### In the application, I use the MVVM architecture.

### Application interface:
<img width="240" alt="mainMenu" src=https://github.com/n1kitka/MuseumSwiftUI/assets/98713485/bc995452-9927-445a-83f7-58c788204ddf>

### User profile:
<img width="240" alt="userProfile" src=https://github.com/n1kitka/MuseumSwiftUI/assets/98713485/609c9792-1a74-4143-afef-646a6172f017>

### The image below shows the name, description, materials and cosine similarity of the exhibit, rounded to 0.09.
<img width="240" alt="objectPage" src="https://github.com/n1kitka/MuseumSwiftUI/assets/98713485/66327882-c2c7-4f8b-946e-a5344bb05499">

### Also, based on the cosine similarity calculation, if its value exceeds 0.2, the collection is moved from “All” to “Favourites”
<img width="240" alt="image" src="https://github.com/n1kitka/MuseumSwiftUI/assets/98713485/fd86b312-09b1-41c6-aec3-8bc53176950e">
<img width="240" alt="image" src="https://github.com/n1kitka/MuseumSwiftUI/assets/98713485/a6c3d5d3-fbb0-4750-abf1-1b110f4a71ac">
<img width="240" alt="image" src="https://github.com/n1kitka/MuseumSwiftUI/assets/98713485/db67aa7d-8bfa-4b62-823c-c6c5bb11dcdb">

### In the context of museum recommendations, MSE calculates the mean squared error between the user's survey responses and the characteristics of each museum. The museum with the lowest MSE value is the most relevant to the user because its profile most closely matches the user's preferences.
<img width="240" alt="image" src="https://github.com/n1kitka/MuseumSwiftUI/assets/98713485/b176347a-7323-46d5-bb5d-4181fd306e6c">

### The image below shows the "Astronomical Museum of Taras Shevchenko Kyiv National University", which was recommended after filling out the survey and clicking on the "Get recommendation" button
<img width="240" alt="image" src=https://github.com/n1kitka/MuseumSwiftUI/assets/98713485/e56798d4-ae7d-47d5-aaee-dbeed0e42d00>








