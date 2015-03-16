This API allows to access FFFFOUND's content: users, images, etc.
Used in [FFFFOUND Desktop](http://toki-woki.net/p/FFFFOUND-Desktop/).

Although unofficial, this API is made with Keita Kitamura's permission.
Project's blog post: http://toki-woki.net/blog/?p=336

---

**Important notes**:
  * For now, this API will only work in AIR projects because ffffound.com's crossdomain.xml is too restrictive. I've contacted them but at this time they don't want to change it.
  * The API relies on FFFFOUND's RSS feeds but also on the site's pages' HTML, so some functionalities might break at any time without warning. Use with caution.

---

Dependencies :
  * http://code.google.com/p/as3corelib/
  * http://code.google.com/p/as3syndicationlib/