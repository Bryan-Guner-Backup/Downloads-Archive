package com.lambda_labs.community_calendar.viewmodel

import EventsQuery
import android.os.Bundle
import androidx.appcompat.widget.SearchView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.constraintlayout.widget.ConstraintSet
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.google.android.material.button.MaterialButton
import com.lambda_labs.community_calendar.Repository
import com.lambda_labs.community_calendar.model.Filter
import com.lambda_labs.community_calendar.model.Search
import com.lambda_labs.community_calendar.util.dpToPx
import com.lambda_labs.community_calendar.util.getSearchDate
import com.lambda_labs.community_calendar.util.negativeDate
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import io.reactivex.schedulers.Schedulers

@Suppress("UNCHECKED_CAST")
class SearchViewModel(private val repo: Repository): ViewModel() {
    // Database call will be done in viewmodel
    private var disposable: Disposable? = null
    private var searchDisposable: Disposable? = null
    private val recentSearchList: MutableLiveData<MutableList<Search>> = MutableLiveData(
        mutableListOf())
    val searchList: LiveData<MutableList<Search>> = recentSearchList

    fun getAllEvents(): LiveData<List<EventsQuery.Event>> {
        return repo.events
    }

    // For MainActivity, add a Recent Search to room's database
    fun addRecentSearch(search: Search){
        fun searchToString(theSearch: Search): String{
            val ourSearchString = StringBuilder()
            ourSearchString.append(theSearch.zipcode.toString())
            ourSearchString.append(theSearch.searchText)
            ourSearchString.append(theSearch.tags.toString())
            ourSearchString.append(theSearch.location)
            ourSearchString.append(getSearchDate(theSearch.date))
            return ourSearchString.toString()
        }

        var didAnyItemsMatch = false
        recentSearchList.value?.forEach {
            if (searchToString(search).equals(searchToString(it), ignoreCase = true)){
                didAnyItemsMatch = true
            }
        }
        if (!didAnyItemsMatch){
            searchDisposable = Schedulers.io().createWorker().schedule {
                repo.addRecentSearch(search)
            }
        }
    }



    // Retrieves searches stored in database and saves them to recentSearchList to pass to searchList for fragment
    fun getRecentSearches(){
        disposable = repo.getRecentSearchList().subscribeOn(Schedulers.io())
            .observeOn(AndroidSchedulers.mainThread()).subscribe{ searches: MutableList<Search> ->
                recentSearchList.value?.clear()
                recentSearchList.value = searches
            }
    }

    fun updateRecentSearch(search: Search){
        repo.updateRecentSearch(search)
    }

    fun removeRecentSearch(search: Search){
        repo.removeRecentSearch(search)
    }

    /* Checks filters to see if the user changed any then adds them
    to a list which is used in RecentSearchRecycler */
    fun searchToSearchList(search: Search): ArrayList<Any> {
        val list = ArrayList<Any>()
        val location = search.location
        if (location.isNotEmpty()) list.add(location)
        val zipcode = search.zipcode
        if (zipcode != -1) list.add(zipcode)
        val date = search.date
        if (date != negativeDate()) list.add(date)
        val tags = search.tags
        if (tags[0].isNotEmpty()) list.add(tags)

        return list
    }
    // Checks search to see if any filters have been added
    fun hasNoFilters(search: Search): Boolean {
        val checkLocation = search.location.isEmpty()
        val checkZipcode = search.zipcode == -1
        val checkDate = search.date == negativeDate()
        val checkTags = search.tags[0].isEmpty()
        return checkLocation && checkZipcode && checkDate && checkTags
    }

    fun getFilterCount(filter: Filter?): Int{
        var filterCount = 0
        if (filter != null){
            if (filter.tags.isNotEmpty()) filter.tags.forEach { filterCount++ }
            if (filter.date.isNotEmpty()) filterCount++
            if (filter.location.isNotEmpty()) filterCount++
            if (filter.zip.isNotEmpty()) filterCount++
        }
        return filterCount
    }


    fun setupSearchBarConstraints(parent: ConstraintLayout, search: SearchView, cancel: MaterialButton, filters: MaterialButton){
        val dpToPx = dpToPx(10f, parent.context.resources)
        val constraintSet = ConstraintSet()
        constraintSet.clone(parent)
        // Search Bar
        constraintSet.connect(search.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP)
        constraintSet.connect(search.id, ConstraintSet.START, filters.id, ConstraintSet.START, 0)
        constraintSet.connect(search.id, ConstraintSet.END, cancel.id, ConstraintSet.START)
        constraintSet.connect(filters.id, ConstraintSet.TOP, search.id, ConstraintSet.BOTTOM, dpToPx)

        // Cancel Button
        constraintSet.connect(cancel.id, ConstraintSet.TOP, search.id, ConstraintSet.TOP)
        constraintSet.connect(cancel.id, ConstraintSet.BOTTOM, search.id, ConstraintSet.BOTTOM)
        constraintSet.connect(cancel.id, ConstraintSet.START, search.id, ConstraintSet.END, dpToPx)
        constraintSet.connect(cancel.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, 0)

        constraintSet.applyTo(parent)
    }

    // Disposes of the disposable to prevent memory leak
    override fun onCleared() {
        if (disposable != null){
            disposable?.dispose()
        }
        if (searchDisposable != null){
            searchDisposable?.dispose()
        }
        super.onCleared()
    }
}