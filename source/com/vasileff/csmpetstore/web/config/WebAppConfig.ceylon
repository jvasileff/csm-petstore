import com.google.common.collect {
    ImmutableList {
        listOf=\iof
    }
}
import com.vasileff.csmpetstore.config {
    AppConfig
}

import javax.servlet {
    Filter
}

import org.springframework.context.annotation {
    configuration,
    bean,
    importConfiguration=\iimport
}
import org.springframework.web.filter {
    HiddenHttpMethodFilter,
    CharacterEncodingFilter,
    CompositeFilter
}

configuration shared
importConfiguration({`AppConfig`})
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
