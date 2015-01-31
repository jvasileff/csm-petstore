import com.google.common.collect {
    ImmutableList {
        listOf=\iof
    }
}

import javax.servlet {
    Filter
}

import org.springframework.context.annotation {
    configuration,
    bean
}
import org.springframework.web.filter {
    HiddenHttpMethodFilter,
    CharacterEncodingFilter,
    CompositeFilter
}


configuration shared
class WebAppConfig() {

    shared default bean {name={"webAppFilters"};}
    Filter webAppFilters() {
        value compositeFilter = CompositeFilter();
        compositeFilter.setFilters(
            listOf(characterEncodingFilter(),
                   hiddenHttpMethodFilter()));
        return compositeFilter;
    }

    shared default bean
    Filter characterEncodingFilter() {
        value filter = CharacterEncodingFilter();
        filter.setEncoding("UTF-8");
        return filter;
    }

    shared default bean
    Filter hiddenHttpMethodFilter()
        =>  HiddenHttpMethodFilter();

}