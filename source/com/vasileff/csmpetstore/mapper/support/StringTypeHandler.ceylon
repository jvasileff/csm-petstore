import java.sql {
    ResultSet,
    CallableStatement,
    PreparedStatement
}

import org.apache.ibatis.type {
    BaseTypeHandler,
    JdbcType
}

shared
class StringTypeHandler() extends BaseTypeHandler<String>() {

    shared actual
    String? getNullableResult(ResultSet? resultSet, String? columnName)
        =>  resultSet?.getString(columnName);

    shared actual
    String? getNullableResult(ResultSet? resultSet, Integer index)
        =>  resultSet?.getString(index);

    shared actual
    String? getNullableResult(CallableStatement? callableStatement, Integer index)
        =>  callableStatement?.getString(index);

    shared actual
    void setNonNullParameter(PreparedStatement? preparedStatement,
                             Integer index, String string, JdbcType? jdbcType)
        =>  preparedStatement?.setString(index, string);
}
