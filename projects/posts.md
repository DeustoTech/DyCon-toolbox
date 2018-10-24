---
layout: project
title: Posts
description: "Divulgative concepts of control problems in real life"
header-img: "img/home-bg.gif"
---

{% for post in site.posts %}
{% if post.categories contains page.title %}
<div class="post-preview">
    <a href="{{ post.url | prepend: site.baseurl }}">
        <h2 class="post-title"> {{ post.title }}
        </h2>
        {% if post.subtitle %}
        <h3 class="post-subtitle">
            {{ post.subtitle }}
        </h3>
        {% endif %}
    </a>
    <p class="post-meta" style="margin-bottom:5px">
            {% for author in post.author %}
            {{ site.data.members[author].name }} -
            {% endfor %}
            {{ post.date | date: "%B %-d, %Y" }}
    </p>
	<div class="notepad-index-post-tags" style="">
		{% for tag in post.tags %}<a href="{{ site.baseurl }}/search/index.html#{{ tag | cgi_encode }}" title="Other posts from the {{ tag | capitalize }} tag">{{ tag | capitalize }}</a>{% unless forloop.last %}&nbsp;{% endunless %}{% endfor %}
	</div>
</div>
<hr>
{% endif %}
{% endfor %}