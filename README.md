# CRIOS Website

The source code for the CRIOS group website.
This is based on the 
[Agency Jekyll Theme](https://github.com/raviriley/agency-jekyll-theme), 
created by [raviriley](https://github.com/raviriley).

## Adding to "About", "Group", or "Publications" sections

- Modify text in [\_data/sitetext.yml](https://github.com/crios-ut/crios-ut.github.io/blob/master/_data/sitetext.yml).
- Add images to [assets/img](https://github.com/crios-ut/crios-ut.github.io/tree/master/assets/img), and subfolders within
- For now, if no image is added with a publication entry, be sure to fill the `img:`
    portion with a blank parenthesis: "" , otherwise a gray box fills

## Adding to "Research" or "Outreach" sections

- add a new file which describes the project, event, etc to the [\_outreach](https://github.com/crios-ut/crios-ut.github.io/tree/master/_outreach) or [\_research](https://github.com/crios-ut/crios-ut.github.io/tree/master/_research) sections
- the top portion, denoted by `---` above and below, specifies the content
    to show when this link is clicked on (title, subtitle, and main image).
    The corresponding content under "caption:", title, subtitle, and thumbnail 
    specify what the "link" looks like on the home page.
    
- text below this is rendered as kramdown markdown, see [here](https://kramdown.gettalong.org/quickref.html) for a syntax guide
