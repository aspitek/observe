function parse_log(tag, timestamp, record)
    local new_record = {}
    if not record then
        print("Error: Empty record received")
        return 0, timestamp, {}
    end
    if record.time and record.log then
        new_record = record
    else
        print("Warning: Missing time or log in record: " .. table.concat(record, " "))
        new_record.time = os.date("%Y-%m-%dT%H:%M:%S")
        new_record.log = record.log or table.concat(record, " ")
    end
    if record.stream then
        new_record.stream = record.stream
    end
    return 1, timestamp, new_record
end