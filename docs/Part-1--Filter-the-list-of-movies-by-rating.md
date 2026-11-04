# Part 1: Filter the list of movies by rating

_Suggestion: Read this whole page before starting to code!  There are hints and an overview of the big picture here!_

Before modifying the code, create a feature branch with `git checkout -b add-filtering`.  Commit your changes frequently.

Enhance RottenPotatoes as follows. At the top of the All Movies listing, add some checkboxes that allow the user to filter the list to show only movies with certain MPAA ratings:

![Screenshot. The filter should be included somewhere below the page heading. It should have a checkbox for each rating, followed by a "Refresh" button.](img/filter-screenshot.png)

When the Refresh button is pressed, the list of movies is redisplayed showing only those movies whose ratings were checked. If _no_ boxes are checked, after a user hits the Refresh button, all movies should be listed, and all checkboxes should be checked. It also applies to the first time when the user visits the page (i.e. when the user visits the page, all checkboxes should be checked).

This will require a couple of pieces of code. We have provided the code that generates the checkboxes form, which you can include in the `index.html.erb` template.  

```erb
<%= form_with url: movies_path, method: :get, id: 'ratings_form', local: true do %>
  Include:
  <% @all_ratings.each do |rating| %>
    <div class="form-check  form-check-inline">
      <%= check_box_tag "ratings[#{rating}]", "1", @ratings_to_show.include?(rating), class: 'form-check-input' %>
      <%= label_tag "ratings[#{rating}]", rating, class: 'form-check-label' %>
    </div>
  <% end %>
  <%= submit_tag 'Refresh', id: 'ratings_submit', class: 'btn btn-primary' %>
  
<% end %>
```

BUT, you have to do a bit of work to use the above code:

1. As you can see, it expects the variable `@all_ratings` to be an enumerable collection of all possible values of a movie rating, such as `['G','PG','PG-13','R']`. The controller action needs to set up this variable. And since the possible values of movie ratings are really the responsibility of the Movie model, it's best if the controller sets this variable by consulting the Model. Hence, good form would be to create a class method of `Movie` that returns an appropriate value for this collection, say `Movie.all_ratings`, and have the controller assign that to the appropriate instance variable for the view to pick up.

2. The [Rails documentation](https://api.rubyonrails.org/v8.1.4/) for `check_box_tag` says that the third value, evaluated as a Boolean, tells whether the checkbox should be displayed as checked or not.  In the code above, `@ratings_to_show` is assumed to be a collection of which ratings should be checked.  So `@ratings_to_show.include?('G')` would be true if `'G'` was a member of the collection.  The controller action must also set up this array, _even if no check boxes are checked._

<details>
<summary>
Why must the controller set up a default value for
<code>@ratings_to_show</code> even if nothing is checked?
</summary>
<blockquote>
If it doesn't, then <code>@ratings_to_show</code> will have a <code>nil</code> value in the
view, and trying to call <code>nil.include?</code> will cause an exception.
</blockquote>
</details>
<p></p>

You will also need code in the controller that knows (i) how to figure out which boxes the user checked and (ii) how to restrict the database query based on that result.

Regarding (i), you'll see that the checkboxes have field names like `ratings[G]`, `ratings[PG]`, etc. This trick will cause Rails to aggregate the values into a single hash called `ratings`, whose keys will be the names of the checked boxes only, and whose values will be the value attribute of the checkbox (which is "1" by default, as explicitly specified in the `check_box_tag` call). That is, if the user checks the **G** and **R** boxes, `params` will include as one of its values `:ratings=>{"G"=>"1", "R"=>"1"}`. Check out the `Hash` documentation for an easy way to grab just the keys of a hash, since we don't care about the values in this case (checkboxes that weren't checked don't appear in the `params` hash at all).

Regarding (ii), you'll probably end up replacing `Movie.all` in the controller method. Since most interesting code should go in the model rather than exposing details of the schema to the controller, consider defining a class-level method in the model such as `Movie.with_ratings(ratings)` that takes an array of ratings (e.g. `["r", "pg-13"]`) and returns an ActiveRecord relation of movies whose rating matches (case-insensitively) anything in that array.  To do its job, this method can make use of `Movie.where`, which has various options to help you restrict the database query.

**Hint:** read the [documentation](https://api.rubyonrails.org/v8.1.4) about `ActiveRecord::Base` (on the docs page, click the flippy triangle next to the class name `ActiveRecord` and find the interior class `Base`) for examples of how to use `where` to do queries like this. The [Practice with ActiveRecord Basics](https://learn.sewanee.edu/d2l/le/content/46396/viewContent/437786/View) may be helpful too. You may also find `.present?` convenient.

### More Hints

_We suggest_ adding a class method in `Movie` as follows:

```ruby
class Movie < ApplicationRecord
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
  end
end
```

Take a look at what is in `params[]` when the form is submitted with various checkboxes checked, and particularly, what is in `params[:ratings]` (or `params['ratings']` -- special hashes in Rails such as `params` and `session` can be accessed by either strings or symbols, even though hashes in Ruby do not generally behave this way).

Notice that you will need to use the `params[:ratings]` values in two ways in the controller: to determine what values to pass to `Movie.with_ratings`, and to set a variable that can be used by the view so that the appropriate checkboxes show up as checked when the filtered view is loaded.

### To pay attention to...

**Labels** You may notice that we have included a HTML `label` alongside the checkbox. These labels are critical for a properly functioning form! Primarily, they tell users what checkbox they are about to select. However, labels also provide built-in accessibility features (such as for blind users, so they too know what each checkbox does) or handy shortcuts like clicking "G" to apply the "G" checkbox. (On a phone, for example, this means users are less likely to tap on the wrong action.)

**Reminder** Don't put logic in your views! If you find yourself doing computation in your views, set up an instance variable in the controller and do the computation there instead. And if the computation is anything more than trivial, it probably belongs in a model, not in the controller.

## Deploying this feature

Once you've verified that your code works (by running the Rails server locally and trying it), we'll try deploying what we've made so far to the Render web service. This time, let's use the `main` branch of your repository. That means we'll have to merge our current branch into `main`.

First, stage your changes and commit them to the feature branch you created. Then, check out your `main` branch:

```sh
git checkout main
```

Now, let's manually merge the new feature branch into `main`. This is what GitHub is doing when you press the "Merge pull request" button.

```sh
git merge <FEATURE_BRANCH_NAME>
```

<details>
  <summary><strong>Self Check Question:</strong> What would happen if, while you were working on your feature branch, someone else had made changes to the <code>main</code> branch of the remote on the same parts of the same files you just edited?</summary>
  <p><blockquote>This is where the dreaded <em>merge conflict</em> comes from. When you run <code>git merge</code>, Git will check whether your changes conflict with changes made in the branch you're merging into. If there are conflicts, you'll be asked to resolve those conflicts yourself before committing the merge. Fortunately, in this project, <code>main</code> hasn't been updated since you created your feature branch off the <code>main</code> branch, so merging will be a breeze.</blockquote></p>
</details>
<p></p>

This will update the `main` branch to include the commits from your feature branch. And, since you won’t need the feature branch anymore, you can clean up by deleting it:

```sh
git branch -d <FEATURE_BRANCH_NAME>
```

Again, when you're merging into `main`, it's typically better to use the pull request flow; we used the manual merge technique here just to give you a peek under the hood. One risk of doing the merge-to-main process yourself is that things get messy if two people try to merge their feature branches into `main` at the same time. Git's distributed nature, with a copy of the repository on each system, means there's nothing preventing two people from making changes to the `main` branch at the same time. GitHub's merge button will quickly perform the merges in sequence for you, applying one at a time to prevent this issue.

Now that we've got our code on `main`, push it to GitHub. Render automatically deploys the new commit:

```sh
git push origin main
```

Have a peek at the new changes and make sure they're working properly before moving onto the next section.

-----

Next: [Part 2: Sort the list of movies](Part-2--Sort-the-list-of-movies.md)
