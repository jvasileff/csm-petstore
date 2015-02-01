import org.apache.ibatis.type {
    BaseTypeHandler,
    JdbcType
}
import ceylon.time {
    Instant
}
import java.sql {
    ResultSet,
    CallableStatement,
    PreparedStatement,
    Timestamp
}

shared
class InstantTypeHandler() extends BaseTypeHandler<Instant>() {

    shared actual
    Instant? getNullableResult(ResultSet resultSet, String columnName)
        =>  asInstant(resultSet.getTimestamp(columnName));

    shared actual
    Instant? getNullableResult(ResultSet resultSet, Integer index)
        =>  asInstant(resultSet.getTimestamp(index));

    shared actual
    Instant? getNullableResult(CallableStatement callableStatement, Integer index)
        =>  asInstant(callableStatement.getTimestamp(index));

    shared actual
    void setNonNullParameter(PreparedStatement preparedStatement, Integer index,
                             Instant instant, JdbcType jdbcType)
        =>  preparedStatement.setTimestamp(index, Timestamp(instant.millisecondsOfEpoch));

    Instant? asInstant(Timestamp? timestamp)
        =>  if (exists timestamp)
            then Instant(timestamp.time)
            else null;
}
