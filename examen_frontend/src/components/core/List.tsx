interface ListProps {
  items: { title: string; value: React.ReactNode }[];
  renderSlot: (item: { title: string; value: React.ReactNode }) => React.ReactNode;
}

const List: React.FC<ListProps> = ({ items, renderSlot }) => {
  return (
    <div className="mt-14">
      <dl className="-my-4 divide-y">
        {items.map((item, i) => (
          <div key={i} className="flex gap-4 py-4 text-sm leading-6 sm:gap-8">
            <dt className="w-1/4 flex-none">{item.title}</dt>
            <dd>{renderSlot(item)}</dd>
          </div>
        ))}
      </dl>
    </div>
  );
};


export default List;