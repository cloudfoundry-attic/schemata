# Intro

The issue that Schemata attempts to solve is the problem of handling
messages sent between old and new components. Different versions of
components may expect messages to conform to different schemas, as
schemas are updated to expect new fields, different types for fields, or
the removal of fields from messsages.

The motivating use-case is the rolling deployment of CF jobs. During a
new deployment, new jobs/components are brought up one at a time. Thus,
there is a period of time where the new jobs must communicate with old
jobs already running prior to the new deployment.

The goal, then, is to devise a message structure that allows new and old
jobs to contain all the necessary information to speak to each other,
while still maintining the ability to ensure that messages conform to
pre-specified schemas.

# Usage

When a component -- called, very originally, 'Component' in this
explanation -- receives a json-encoded message, it can validate that the
message is a properly-defined 'Foo' message with the following call:

    msg_obj = Schemata::Component.validate_foo json_msg

The return value is an object of type Schemata::Component::Foo::Vxx, 
where xx is the number of the current message version.

Likewise, when our component wants to emit a Foo message from a hash of
required data, it can create a properly-encoded json msg from the data:

    json = Schemata::Component.create_foo_msg data_hash

The returned json message contains more information than the provided
hash; it conforms to a structure required by Schemata (see next
section).

# Message structure 

## 'min_version'

Every Schemata message must contain an Intger field called 'min_version', 
whose purpose is to designate the lowest version that can still properly
validate the given message. This allows for several generations of a
message to be deployed at once, or for non-consecutive deployments to be
running (e.g., a very old deployment being updated).

## Backwards compatibility

Every message must maintain those fields removed or modified from the 
previous versions of the schema. For each previous version xx (down to
'min_version'), the message includes a field called 'Vxx'. The
corresponding value is a hash with all the fields removed/modified
between versions xx-1 and xx.

With these old fields, a component can overwrite the future data
with the backwards compatible data.

In every schema definition, a method (called generate_old_fields) must
be provided to generate this 'delta' of fields from version xx-1 to
version xx. The method create_foo_msg calls this method and constructs
the full Schemata message.

## Forward Compatibility

Each component must be able to 'upvert' old messages to conform to the
current schema. Providing code to do this is considered part of the
schema definition, and the method must be provided by a developer when a
new schema is specified.

When a call is made to validate_foo, old messages are upverted before
validation.

## An example

Suppose a v11 Foo message has the following schema:

    schema = {
      'foo1' => String,
      'foo2' => String
    }

Then a new v12 schema is defined for foo messages:

    schema = {
      'foo1' => String,
      'foo2' => Integer,
      'foo3' => Integer
    }

    \# Crappy Pseudocode to get the gist of it
    def upvert old_message
      old_message['foo2'].to_i
      old_message['foo3'] = 1
    end

    def generate_old_fields
      { 'foo2' => @foo2.to_s }
    end

During the deployment, a v12 job wants to emit the following
information:

    msg = {
      'foo1' => 'foo',
      'foo2' => 2,
      'foo3' => 3
    }

To remain backwards compatible, it must include additional information
and emit a json message:

    {
      'min_version' : 11,
      'V11' : {
        'foo2' => '2'
      },
      'V12' : {
        'foo1' => 'foo',
        'foo2' => 2,
        'foo3' => 3
      }
    }

Now, when the v12 component recieves a message from a v11 component, it
recieves the following data:

    {
      'min_version' : 11,
      'V11': {
        'foo1' : 'foo',
        'foo2' : '2'
      }
    }

It parses out the V11 hash and passes it to the upvert function. The
result is:

    msg = {
      'foo1' => 'foo',
      'foo2' => 2,
      'foo3' => 1
    }

a valid v12 message!

# Files in this project (so far)

In the lib folder, you can find the schemata/component directory. This
contains all the logic of the hypothetical gem thus far. 

component.rb -- contains the definition of the Schemata::Component
namespace and its two functions, validate_foo and create_foo_msg

error.rb -- a definition of the Schemata::MsgError class

foo/foo.rb -- a central point for requiring all the different versions
of the foo message. Also defines a constant CURRENT that specifies the
current version of the Foo message

foo/foo_v*.rb -- definitions of successive versions of the Foo message.
