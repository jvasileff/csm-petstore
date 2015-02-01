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
class IntegerTypeHandler() extends BaseTypeHandler<Integer>() {

    shared actual
    Integer? getNullableResult(ResultSet? resultSet, String? columnName)
        =>  resultSet?.getInt(columnName);

    shared actual
    Integer? getNullableResult(ResultSet? resultSet, Integer index)
        =>  resultSet?.getInt(index);

    shared actual
    Integer? getNullableResult(CallableStatement? callableStatement, Integer index)
        =>  callableStatement?.getLong(index);

    shared actual
    void setNonNullParameter(PreparedStatement? preparedStatement,
                             Integer index, Integer integer, JdbcType? jdbcType)
        =>  preparedStatement?.setLong(index, integer);
}
