package com.vasileff.csmpetstore.config;

public class UnsafeUtil {

    @SuppressWarnings("unchecked")
    public static <T> T cast(Object obj) {
        return (T) obj;
    }

}
