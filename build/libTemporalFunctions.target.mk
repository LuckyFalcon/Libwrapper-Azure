# This file is generated by gyp; do not edit.

TOOLSET := target
TARGET := libTemporalFunctions
DEFS_Debug := \
	'-DNODE_GYP_MODULE_NAME=libTemporalFunctions' \
	'-DUSING_UV_SHARED=1' \
	'-DUSING_V8_SHARED=1' \
	'-DV8_DEPRECATION_WARNINGS=1' \
	'-DV8_DEPRECATION_WARNINGS' \
	'-DV8_IMMINENT_DEPRECATION_WARNINGS' \
	'-D_LARGEFILE_SOURCE' \
	'-D_FILE_OFFSET_BITS=64' \
	'-D__STDC_FORMAT_MACROS' \
	'-DOPENSSL_NO_PINSHARED' \
	'-DOPENSSL_THREADS' \
	'-DNAPI_DISABLE_CPP_EXCEPTIONS' \
	'-DBUILDING_NODE_EXTENSION' \
	'-DDEBUG' \
	'-D_DEBUG' \
	'-DV8_ENABLE_CHECKS'

# Flags passed to all source files.
CFLAGS_Debug := \
	-fPIC \
	-pthread \
	-Wall \
	-Wextra \
	-Wno-unused-parameter \
	-m64 \
	-g \
	-O0

# Flags passed to only C files.
CFLAGS_C_Debug :=

# Flags passed to only C++ files.
CFLAGS_CC_Debug := \
	-fno-rtti \
	-std=gnu++1y

INCS_Debug := \
	-I/home/api/.cache/node-gyp/12.16.3/include/node \
	-I/home/api/.cache/node-gyp/12.16.3/src \
	-I/home/api/.cache/node-gyp/12.16.3/deps/openssl/config \
	-I/home/api/.cache/node-gyp/12.16.3/deps/openssl/openssl/include \
	-I/home/api/.cache/node-gyp/12.16.3/deps/uv/include \
	-I/home/api/.cache/node-gyp/12.16.3/deps/zlib \
	-I/home/api/.cache/node-gyp/12.16.3/deps/v8/include \
	-I/home/api/libwrapper2/node_modules/node-addon-api \
	-I$(srcdir)/node_modules/nan

DEFS_Release := \
	'-DNODE_GYP_MODULE_NAME=libTemporalFunctions' \
	'-DUSING_UV_SHARED=1' \
	'-DUSING_V8_SHARED=1' \
	'-DV8_DEPRECATION_WARNINGS=1' \
	'-DV8_DEPRECATION_WARNINGS' \
	'-DV8_IMMINENT_DEPRECATION_WARNINGS' \
	'-D_LARGEFILE_SOURCE' \
	'-D_FILE_OFFSET_BITS=64' \
	'-D__STDC_FORMAT_MACROS' \
	'-DOPENSSL_NO_PINSHARED' \
	'-DOPENSSL_THREADS' \
	'-DNAPI_DISABLE_CPP_EXCEPTIONS' \
	'-DBUILDING_NODE_EXTENSION'

# Flags passed to all source files.
CFLAGS_Release := \
	-fPIC \
	-pthread \
	-Wall \
	-Wextra \
	-Wno-unused-parameter \
	-m64 \
	-O3 \
	-fno-omit-frame-pointer

# Flags passed to only C files.
CFLAGS_C_Release :=

# Flags passed to only C++ files.
CFLAGS_CC_Release := \
	-fno-rtti \
	-std=gnu++1y

INCS_Release := \
	-I/home/api/.cache/node-gyp/12.16.3/include/node \
	-I/home/api/.cache/node-gyp/12.16.3/src \
	-I/home/api/.cache/node-gyp/12.16.3/deps/openssl/config \
	-I/home/api/.cache/node-gyp/12.16.3/deps/openssl/openssl/include \
	-I/home/api/.cache/node-gyp/12.16.3/deps/uv/include \
	-I/home/api/.cache/node-gyp/12.16.3/deps/zlib \
	-I/home/api/.cache/node-gyp/12.16.3/deps/v8/include \
	-I/home/api/libwrapper2/node_modules/node-addon-api \
	-I$(srcdir)/node_modules/nan

OBJS := \
	$(obj).target/$(TARGET)/services/functionwrapper/libTemporalFunctions.o

# Add to the list of files we specially track dependencies for.
all_deps += $(OBJS)

# Make sure our dependencies are built before any of us.
$(OBJS): | $(builddir)/nothing.a $(obj).target/node_modules/node-addon-api/src/nothing.a

# CFLAGS et al overrides must be target-local.
# See "Target-specific Variable Values" in the GNU Make manual.
$(OBJS): TOOLSET := $(TOOLSET)
$(OBJS): GYP_CFLAGS := $(DEFS_$(BUILDTYPE)) $(INCS_$(BUILDTYPE))  $(CFLAGS_$(BUILDTYPE)) $(CFLAGS_C_$(BUILDTYPE))
$(OBJS): GYP_CXXFLAGS := $(DEFS_$(BUILDTYPE)) $(INCS_$(BUILDTYPE))  $(CFLAGS_$(BUILDTYPE)) $(CFLAGS_CC_$(BUILDTYPE))

# Suffix rules, putting all outputs into $(obj).

$(obj).$(TOOLSET)/$(TARGET)/%.o: $(srcdir)/%.cc FORCE_DO_CMD
	@$(call do_cmd,cxx,1)

# Try building from generated source, too.

$(obj).$(TOOLSET)/$(TARGET)/%.o: $(obj).$(TOOLSET)/%.cc FORCE_DO_CMD
	@$(call do_cmd,cxx,1)

$(obj).$(TOOLSET)/$(TARGET)/%.o: $(obj)/%.cc FORCE_DO_CMD
	@$(call do_cmd,cxx,1)

# End of this set of suffix rules
### Rules for final target.
LDFLAGS_Debug := \
	-pthread \
	-rdynamic \
	-m64

LDFLAGS_Release := \
	-pthread \
	-rdynamic \
	-m64

LIBS := \
	/home/api/libwrapper2/services/functionwrapper/cppsrc/libTemporal/TemporalLib.a

$(obj).target/TemporalFunctions.node: GYP_LDFLAGS := $(LDFLAGS_$(BUILDTYPE))
$(obj).target/TemporalFunctions.node: LIBS := $(LIBS)
$(obj).target/TemporalFunctions.node: TOOLSET := $(TOOLSET)
$(obj).target/TemporalFunctions.node: $(OBJS) $(obj).target/node_modules/node-addon-api/src/nothing.a FORCE_DO_CMD
	$(call do_cmd,solink_module)

all_deps += $(obj).target/TemporalFunctions.node
# Add target alias
.PHONY: libTemporalFunctions
libTemporalFunctions: $(builddir)/TemporalFunctions.node

# Copy this to the executable output path.
$(builddir)/TemporalFunctions.node: TOOLSET := $(TOOLSET)
$(builddir)/TemporalFunctions.node: $(obj).target/TemporalFunctions.node FORCE_DO_CMD
	$(call do_cmd,copy)

all_deps += $(builddir)/TemporalFunctions.node
# Short alias for building this executable.
.PHONY: TemporalFunctions.node
TemporalFunctions.node: $(obj).target/TemporalFunctions.node $(builddir)/TemporalFunctions.node

# Add executable to "all" target.
.PHONY: all
all: $(builddir)/TemporalFunctions.node

