import org.springframework.web.servlet.view {
    RedirectView
}
import javax.servlet {
    RequestDispatcher
}
import javax.servlet.http {
    HttpServletRequest
}
import com.google.common.base {
    Throwables
}
import ceylon.unicode {
    GeneralCategory,
    markCombiningSpacing,
    punctuationConnector,
    symbolCurrency,
    punctuationDash,
    numberDecimalDigit,
    markEnclosing,
    punctuationClose,
    punctuationFinalQuote,
    punctuationInitialQuote,
    numberLetter,
    letterLowercase,
    symbolMath,
    letterModifier,
    symbolModifier,
    markNonspacing,
    letterOther,
    numberOther,
    punctuationOpen,
    punctuationOther,
    symbolOther,
    separatorParagraph,
    separatorSpace,
    letterTitlecase,
    letterUppercase,
    generalCategory,
    separatorLine
}
import com.vasileff.jl4c.guava.collect {
    ImmutableSet
}

RedirectView redirect(String url)
    =>  RedirectView(url, true);

String? requestPathFor(HttpServletRequest? request) {
    if (exists request) {
        String servletPath;
        String pathInfo;
        if (is String path = request.getAttribute(
                RequestDispatcher.\iFORWARD_SERVLET_PATH)) {
            servletPath = path;
            pathInfo = request.getAttribute(
                RequestDispatcher.\iFORWARD_PATH_INFO)?.string else "";
        }
        else {
            servletPath = request.servletPath;
            pathInfo = request.pathInfo else "";
        }
        return servletPath + pathInfo;
    }
    else {
        return null;
    }
}

String? stackTraceAsString(Throwable? throwable)
    =>  if (exists throwable)
        then Throwables.getStackTraceAsString(throwable)
        else null;

String sanitizeForLog(
        String raw,
        Boolean allowVerticalSpace=false)
    =>  String(raw.map((c)
        =>  if (clean(c, allowVerticalSpace))
            then c
            else '\{#fffd}'));

Boolean clean(
        Character character,
        Boolean allowVerticalSpace)
    =>  let (gc = generalCategory(character))
        cleanGCs.contains(gc) ||
        character == '\t' ||
        allowVerticalSpace && (
            gc == separatorLine ||
            character == '\n' ||
            character == '\r' ||
            character == '\f' ||
            character == '\{#000B}');

Set<GeneralCategory> cleanGCs = ImmutableSet({
    letterLowercase,
    letterModifier,
    letterOther,
    letterTitlecase,
    letterUppercase,
    markCombiningSpacing,
    markEnclosing,
    markNonspacing,
    numberDecimalDigit,
    numberLetter,
    numberOther,
    punctuationClose,
    punctuationConnector,
    punctuationDash,
    punctuationFinalQuote,
    punctuationInitialQuote,
    punctuationOpen,
    punctuationOther,
    separatorParagraph,
    separatorSpace,
    symbolCurrency,
    symbolMath,
    symbolModifier,
    symbolOther
});
