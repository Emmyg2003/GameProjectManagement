package handle_maps

import "core:mem"
import "core:fmt"
import "base:builtin"

/*This outlines the Handle_Map function allowing the storage of handles like technology lists and item lists*/
Handle_Map :: struct($T: typeid){
	handles: [dynamic]Handle,
	values: [dynamic]T,
	sparse_indices: [dynamic]Sparse_Index,
	next: u16,
}

Handle :: struct{
	generation: u16,
	index: u16,
}

Sparse_Index :: struct{
	generation: u16,
	index_or_next: u16,
}

init :: proc(m: ^$M/Handle_Map($T), allocator := context.allocator){
	m.handles.allocator = allocator
	m.values.allocator = allocator
	m.sparse_indices.allocator = allocator
	m.next = 0
}

destroy :: proc(m: ^$M/Handle_Map($T)){
	clear(m)
	delete(m.handles)
	delete(m.values)
	delete(m.sparse_indices)
}

clear :: proc(m: ^$M/Handle_Map($T)){
	builtin.clear(&m.handles)
	builtin.clear(&m.values)
	builtin.clear(&m.sparse_indices)
	m.next = 0
}

@(require_results)
has_handle :: proc(m: $M/Handle_Map($T), h: Handle) -> bool{
	if h.index < u32(len(m.sparse_indices)){
		return m.sparse_indices[h.index].generation == h.generation
	}
	return false
}

@(require_results)
get :: proc(m: ^$M/Handle_Map($T), h: Handle) -> (^T, bool) {
	if h.index < u16(len(m.sparse_indices)){
		entry := m.sparse_indices[h.index]
		if entry.generation == h.generation{
			return &m.values[entry.index_or_next], true
		}
	}
	return nil, false
}

@(require_results)
insert :: proc(m: ^$M/Handle_Map($T), value: T) -> (handle: Handle){
	if m.next < u16(len(m.sparse_indices)){
		entry := &m.sparse_indices[m.next]
		assert(entry.generation < max(u16), "Generation sparse indices overflow")

		entry.generation += 1
		handle = Handle{
			generation = entry.generation,
			index = m.next,
		}
		m.next = entry.index_or_next
		entry.index_or_next = u16(len(m.handles))
		append(&m.handles, handle)
		append(&m.values, value)

	} else {
		assert(m.next < max(u16), "Index sparse indices overflow")

		handle = Handle{
			index = u16(len(m.sparse_indices)),
		}
		append(&m.sparse_indices, Sparse_Index{
			index_or_next = u16(len(m.handles))
		})
		append(&m.handles, handle)
		append(&m.values, value)
		m.next += 1
	}
	return
}

remove :: proc(m: ^$M/Handle_Map($T), h: Handle) -> (value: Maybe(T)) {
	if h.index < u32(len(m.sparse_indices)) {
		entry := &m.sparse_indices[h.index]
		if entry.generation != h.generation {
			return
		}
		index := entry.index_or_next
		entry.generation += 1
		entry.index_or_next = m.next
		m.next = h.index
		value = m.values[index]
		unordered_remove(&m.handles, int(index))
		unordered_remove(&m.values,  int(index))
		if index < u32(len(m.handles)) {
			m.sparse_indices[m.handles[index].index].index_or_next = index
		}
	}
	return
}