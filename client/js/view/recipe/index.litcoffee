# Index: Main Recipes Component

The recipes Index view manages the part of the application that allows viewing
and editing the recipes. This view allows adding new recipes, viewing recipes,
editing recipes, and filtering the list of recipes.

    `/** @jsx React.DOM */`
    React = require 'react'
    _     = require 'lodash'

    AddRecipe  = require './add_recipe'
    TagList    = require './tag_list'
    RecipeList = require './recipe_list'
    ViewRecipe = require './view_recipe'

    Index = React.createClass
      render: ->

If we are currently filtering the recipe list by a particular tag, we need to
perform the filtering. React encourages us to do this at render time rather
than trying to maintain the filtered list as state. This allows the component
to be stateless.

        if @props.selectedTag
          filteredRecipes = @props.recipes.filter (recipe) =>
            _.contains recipe.get('tags'), @props.selectedTag
        else
          filteredRecipes = @props.recipes

We display the recipe manager in two columns. On the left, there is a button to
add a recipe, the list of tags to filter, and the list of recipes to view. On
the right, we show the currently selected recipe.

        `<div className="row">
          <div className="col-md-3">
            <AddRecipe onAdd={this.handleAddRecipe} />
            <TagList
              tags={this.props.recipes.tags()}
              selectedTag={this.props.selectedTag}
              onSelect={this.props.onSelectTag} />
            <RecipeList
              recipes={filteredRecipes}
              selectedRecipe={this.props.selectedRecipe}
              onSelectRecipe={this.props.onSelectRecipe} />
          </div>
          {this.props.selectedRecipe
            ? <ViewRecipe
                recipe={this.props.selectedRecipe}
                onUpdate={this.handleUpdateRecipe}
                onDelete={this.handleDeleteRecipe} />
            : 'No recipe selected'}
        </div>`

When adding a recipe, we make sure it has the currently selected tag, if there
is one. The parent component makes sure the new recipe becomes selected.

      handleAddRecipe: ->
        @props.onAddRecipe @props.recipes.create tags: _.compact [@props.selectedTag]

When a recipe gets updated, it should already have the changed attributes set
on it before it is passed to us. Our responsibility is to save it and notify
the parent component. (TODO maybe the parent doesn't need to know, as long as
we force an update here)

      handleUpdateRecipe: (recipe) ->
        recipe.save()
        @props.onUpdateRecipe recipe

To delete a recipe, we simply destroy the model. The parent component will clear
the recipe selection if the deleted recipe is currently selected.

      handleDeleteRecipe: (recipe) ->
        recipe.destroy()
        @props.onDeleteRecipe recipe

    module.exports = Index
