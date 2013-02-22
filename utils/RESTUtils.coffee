#
#  Very basic CRUD route creation utility for models.
#  For validation, simply override the model's save method.
#

errMsg = (msg) ->
    return error:
        message: msg.toString()

# ------------------------------
#  List
#
exports.getListController = (model) ->
    (req, res) ->
        # _company: res.user._company
        console.log req.user._company
        model.find {}, (err, result) ->
            if not err
                res.send result
            else
                res.send (errMsg err)

#------------------------------
# Create
#
exports.getCreateController = (model) ->
    return (req, res) ->
        #console.log('create', req.body);
        m = new model req.body
        m.save (err) ->
            if not err
                return m
            else
                return (errMsg err)

#------------------------------
# Read
#
exports.getReadController = (model) ->
    return (req, res) ->
        #console.log('read', req.body);
        model.findById req.params.id, (err, result) ->
            if not err
                return result
            else
                return (errMsg err)

#------------------------------
# Update
#
exports.getUpdateController = (model) ->
    return (req, res) ->
        #console.log('update', req.body);
        model.findById req.params.id, (err, result) ->
            for key in req.body
                result[key] = req.body[key]

            result.save (err) ->
                if not err
                    return result
                else
                    return (errMsg err)

#------------------------------
# Delete
#
exports.getDeleteController = (model) ->
    return (req, res) ->
        #console.log('delete', req.body);
        model.findById req.params.id, (err, result) ->
            if err
                return (errMsg err)
            else
                result.remove()
                result.save (err) ->
                    if not err
                        return {}
                    else
                        return (errMsg err)
